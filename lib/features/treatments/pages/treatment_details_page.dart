import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/models/active_treatment_model.dart';
import '../../../core/models/dose_reminder_model.dart';
import '../../../services/supabase_service.dart';
import '../../../services/treatment_service.dart';
import '../models/treatment_with_medication.dart';
import '../providers/treatments_providers.dart';

class TreatmentDetailsPage extends ConsumerWidget {
  final String treatmentId;

  const TreatmentDetailsPage({super.key, required this.treatmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(treatmentDetailProvider(treatmentId));

    return async.when(
      data: (data) {
        if (data == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(
              child: Text(
                'Treatment not found',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ),
          );
        }
        return _TreatmentDetailsBody(
          key: ValueKey(data.treatment.treatmentId),
          initial: data,
          treatmentId: treatmentId,
        );
      },
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Error loading treatment.\n$e',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

class _TreatmentDetailsBody extends ConsumerStatefulWidget {
  final TreatmentWithMedication initial;
  final String treatmentId;

  const _TreatmentDetailsBody({
    super.key,
    required this.initial,
    required this.treatmentId,
  });

  @override
  ConsumerState<_TreatmentDetailsBody> createState() =>
      _TreatmentDetailsBodyState();
}

class _TreatmentDetailsBodyState extends ConsumerState<_TreatmentDetailsBody> {
  late bool _editing;
  late TextEditingController _nameCtrl;
  late TextEditingController _formCtrl;
  late TextEditingController _doseCtrl;
  late TextEditingController _unitCtrl;
  late TextEditingController _timesCtrl;
  late TextEditingController _intervalCtrl;
  late TextEditingController _quantityCtrl;
  late DateTime _startDate;
  DateTime? _endDate;
  late DateTime _expiryDate;

  @override
  void initState() {
    super.initState();
    _editing = false;
    _nameCtrl = TextEditingController();
    _formCtrl = TextEditingController();
    _doseCtrl = TextEditingController();
    _unitCtrl = TextEditingController();
    _timesCtrl = TextEditingController();
    _intervalCtrl = TextEditingController();
    _quantityCtrl = TextEditingController();
    _applyData(widget.initial);
  }

  @override
  void didUpdateWidget(covariant _TreatmentDetailsBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editing) {
      _applyData(widget.initial);
    }
  }

  void _applyData(TreatmentWithMedication data) {
    final m = data.medication;
    final t = data.treatment;
    _nameCtrl.text = m.tradeNameEn;
    _formCtrl.text = m.dosageForm;
    _doseCtrl.text = _trimTrailingZero(m.doseAmount);
    _unitCtrl.text = m.unit ?? '';
    _timesCtrl.text = '${t.timesPerDay}';
    _intervalCtrl.text = '${t.intervalDays}';
    _quantityCtrl.text = _trimTrailingZero(t.currentQuantity);
    _startDate = t.startDate;
    _endDate = t.endDate;
    _expiryDate = t.expiryDate;
  }

  String _trimTrailingZero(num n) {
    final s = n.toString();
    return s.replaceAll(RegExp(r'\.0$'), '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _formCtrl.dispose();
    _doseCtrl.dispose();
    _unitCtrl.dispose();
    _timesCtrl.dispose();
    _intervalCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  bool get _isActive =>
      widget.initial.treatment.status == TreatmentStatus.active;

  Future<void> _pickDate({
    required BuildContext context,
    required DateTime initial,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onPicked(picked);
  }

  Future<void> _save() async {
    final user = SupabaseService.auth.currentUser;
    if (user == null) return;

    final times = int.tryParse(_timesCtrl.text.trim()) ?? 1;
    final interval = int.tryParse(_intervalCtrl.text.trim()) ?? 1;
    final dose = double.tryParse(_doseCtrl.text.trim()) ?? 0;
    final qty = double.tryParse(_quantityCtrl.text.trim()) ?? 0;

    try {
      await TreatmentService.instance.updateTreatmentAndMedication(
        treatmentId: widget.treatmentId,
        userId: user.id,
        medicationId: widget.initial.treatment.medicationId,
        startDate: _startDate,
        endDate: _endDate,
        timesPerDay: times.clamp(1, 24),
        intervalDays: interval.clamp(1, 365),
        currentQuantity: qty,
        expiryDate: _expiryDate,
        dosageForm: _formCtrl.text.trim(),
        doseAmount: dose,
        unit: _unitCtrl.text.trim().isEmpty ? null : _unitCtrl.text.trim(),
        tradeNameEn: _nameCtrl.text.trim(),
      );
      if (!mounted) return;
      setState(() => _editing = false);
      ref.invalidate(treatmentDetailProvider(widget.treatmentId));
      ref.invalidate(treatmentsListProvider(TreatmentStatus.active));
      ref.invalidate(treatmentsListProvider(TreatmentStatus.completed));
      ref.invalidate(treatmentRemindersProvider(widget.treatmentId));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Treatment updated')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save: $e')),
      );
    }
  }

  Future<void> _confirmEndTreatment() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'End treatment?',
          style: Theme.of(ctx)
              .textTheme
              .titleLarge
              ?.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          'This will mark the treatment as completed.',
          style: Theme.of(ctx)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('End treatment'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    final user = SupabaseService.auth.currentUser;
    if (user == null) return;

    try {
      await TreatmentService.instance
          .completeTreatment(widget.treatmentId, user.id);
      if (!mounted) return;
      ref.invalidate(treatmentsListProvider(TreatmentStatus.active));
      ref.invalidate(treatmentsListProvider(TreatmentStatus.completed));
      ref.invalidate(treatmentDetailProvider(widget.treatmentId));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Treatment completed')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not complete: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final remindersAsync =
        ref.watch(treatmentRemindersProvider(widget.treatmentId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Treatment Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          if (_isActive)
            TextButton(
              onPressed: () {
                setState(() {
                  _editing = !_editing;
                  if (!_editing) _applyData(widget.initial);
                });
              },
              child: Text(_editing ? 'Cancel' : 'Edit'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.35),
                    AppColors.secondary.withValues(alpha: 0.25),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.medication_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 28),
          _LabeledField(
            label: 'Medication Name',
            child: _editing
                ? TextField(
                    controller: _nameCtrl,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: const InputDecoration(),
                  )
                : Text(
                    widget.initial.displayTitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'Form',
                  child: _editing
                      ? TextField(
                          controller: _formCtrl,
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      : Text(
                          widget.initial.medication.dosageForm,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'Dose',
                  child: _editing
                      ? TextField(
                          controller: _doseCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      : Text(
                          '${_trimTrailingZero(widget.initial.medication.doseAmount)} ${widget.initial.medication.unit ?? ''}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                ),
              ),
            ],
          ),
          if (_editing) ...[
            const SizedBox(height: 12),
            _LabeledField(
              label: 'Unit (optional)',
              child: TextField(
                controller: _unitCtrl,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'Start Date',
                  child: _editing
                      ? _DateTile(
                          label: _fmtYmd(_startDate),
                          onTap: () => _pickDate(
                            context: context,
                            initial: _startDate,
                            onPicked: (d) => setState(() => _startDate = d),
                          ),
                        )
                      : Text(
                          _fmtYmd(_startDate),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'End Date',
                  child: _editing
                      ? _DateTile(
                          label: _endDate != null ? _fmtYmd(_endDate!) : '—',
                          onTap: () => _pickDate(
                            context: context,
                            initial: _endDate ?? _startDate,
                            onPicked: (d) => setState(() => _endDate = d),
                          ),
                        )
                      : Text(
                          _endDate != null ? _fmtYmd(_endDate!) : '—',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_editing) ...[
            Row(
              children: [
                Expanded(
                  child: _LabeledField(
                    label: 'Times per day',
                    child: TextField(
                      controller: _timesCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _LabeledField(
                    label: 'Interval (days)',
                    child: TextField(
                      controller: _intervalCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _LabeledField(
                    label: 'Current quantity',
                    child: TextField(
                      controller: _quantityCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _LabeledField(
                    label: 'Expiry date',
                    child: _DateTile(
                      label: _fmtYmd(_expiryDate),
                      onTap: () => _pickDate(
                        context: context,
                        initial: _expiryDate,
                        onPicked: (d) => setState(() => _expiryDate = d),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              child: const Text('Save changes'),
            ),
          ],
          const SizedBox(height: 24),
          _StatusPill(
            status: widget.initial.treatment.status,
          ),
          const SizedBox(height: 28),
          Text(
            'Dose Reminders',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          remindersAsync.when(
            data: (list) {
              if (list.isEmpty) {
                return Text(
                  'No scheduled reminders yet.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                );
              }
              return Column(
                children: list.map((r) => _ReminderRow(
                      reminder: r,
                      intervalDays: widget.initial.treatment.intervalDays,
                    )).toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
            ),
            error: (e, _) => Text(
              'Could not load reminders: $e',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.error),
            ),
          ),
          if (_isActive) ...[
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: _confirmEndTreatment,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: BorderSide(color: AppColors.border.withValues(alpha: 0.8)),
              ),
              child: const Text('Mark as completed'),
            ),
          ],
        ],
      ),
    );
  }
}

String _fmtYmd(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: child,
        ),
      ],
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DateTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_rounded,
              size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final TreatmentStatus status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final isActive = status == TreatmentStatus.active;
    final bg = isActive
        ? AppColors.success.withValues(alpha: 0.18)
        : AppColors.surfaceVariant.withValues(alpha: 0.5);
    final fg = isActive ? AppColors.success : AppColors.textSecondary;
    final label = isActive ? 'Active' : 'Completed';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: fg,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _ReminderRow extends StatelessWidget {
  final DoseReminderModel reminder;
  final int intervalDays;

  const _ReminderRow({
    required this.reminder,
    required this.intervalDays,
  });

  String get _daysLabel =>
      intervalDays <= 1 ? 'Daily' : 'Every $intervalDays days';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppColors.secondary.withValues(alpha: 0.12),
              AppColors.primary.withValues(alpha: 0.08),
            ],
          ),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.access_time_rounded,
                      size: 18, color: AppColors.secondaryLight),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(reminder.plannedTime),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                _daysLabel,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
            Expanded(
              child: Text(
                '${_trimQty(reminder.quantityToTake)} '
                '${reminder.quantityToTake == 1 ? 'pill' : 'pills'}',
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _trimQty(double q) {
    if (q == q.roundToDouble()) return q.toInt().toString();
    return q.toString();
  }

  String _formatTime(String plannedTime) {
    final parts = plannedTime.split(':');
    final h = int.tryParse(parts.isNotEmpty ? parts[0] : '0') ?? 0;
    final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
    final period = h >= 12 ? 'PM' : 'AM';
    final h12 = h % 12 == 0 ? 12 : h % 12;
    return '${h12.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $period';
  }
}
