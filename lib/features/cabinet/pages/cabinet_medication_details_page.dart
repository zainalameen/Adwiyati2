import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/models/active_treatment_model.dart';
import '../../../core/router.dart';
import '../../../services/cabinet_service.dart';
import '../../../services/supabase_service.dart';
import '../../treatments/providers/treatments_providers.dart';
import '../models/cabinet_entry.dart';
import '../providers/cabinet_providers.dart';

class CabinetMedicationDetailsPage extends ConsumerWidget {
  final String cabinetMedId;

  const CabinetMedicationDetailsPage({super.key, required this.cabinetMedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(cabinetDetailProvider(cabinetMedId));

    return async.when(
      data: (data) {
        if (data == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(
              child: Text(
                'Medication not found',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
            ),
          );
        }
        return _CabinetDetailsBody(
          key: ValueKey(data.cabinet.cabinetMedId),
          initial: data,
          cabinetMedId: cabinetMedId,
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
              'Error loading medication.\n$e',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

class _CabinetDetailsBody extends ConsumerStatefulWidget {
  final CabinetEntry initial;
  final String cabinetMedId;

  const _CabinetDetailsBody({
    super.key,
    required this.initial,
    required this.cabinetMedId,
  });

  @override
  ConsumerState<_CabinetDetailsBody> createState() =>
      _CabinetDetailsBodyState();
}

class _CabinetDetailsBodyState extends ConsumerState<_CabinetDetailsBody> {
  late bool _editing;
  late TextEditingController _nameCtrl;
  late TextEditingController _formCtrl;
  late TextEditingController _doseCtrl;
  late TextEditingController _unitCtrl;
  late TextEditingController _qtyCtrl;
  late DateTime _expiryDate;

  @override
  void initState() {
    super.initState();
    _editing = false;
    _nameCtrl = TextEditingController();
    _formCtrl = TextEditingController();
    _doseCtrl = TextEditingController();
    _unitCtrl = TextEditingController();
    _qtyCtrl = TextEditingController();
    _applyData(widget.initial);
  }

  @override
  void didUpdateWidget(covariant _CabinetDetailsBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editing) {
      _applyData(widget.initial);
    }
  }

  void _applyData(CabinetEntry data) {
    final m = data.medication;
    final c = data.cabinet;
    _nameCtrl.text = m.tradeNameEn;
    _formCtrl.text = m.dosageForm;
    _doseCtrl.text = _trimNum(m.doseAmount);
    _unitCtrl.text = m.unit ?? '';
    _qtyCtrl.text = _trimNum(c.quantity);
    _expiryDate = c.expirationDate;
  }

  String _trimNum(num n) {
    if (n == n.roundToDouble()) return n.toInt().toString();
    return n.toString();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _formCtrl.dispose();
    _doseCtrl.dispose();
    _unitCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  String _fmtYmd(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickExpiry() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
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
    if (picked != null) setState(() => _expiryDate = picked);
  }

  Future<void> _save() async {
    final user = SupabaseService.auth.currentUser;
    if (user == null) return;

    final dose = double.tryParse(_doseCtrl.text.trim()) ?? 0;
    final qty = double.tryParse(_qtyCtrl.text.trim()) ?? 0;

    try {
      await CabinetService.instance.updateCabinetAndMedication(
        cabinetMedId: widget.cabinetMedId,
        userId: user.id,
        medicationId: widget.initial.medication.medicationId,
        tradeNameEn: _nameCtrl.text.trim(),
        dosageForm: _formCtrl.text.trim(),
        doseAmount: dose,
        unit: _unitCtrl.text.trim().isEmpty ? null : _unitCtrl.text.trim(),
        quantity: qty,
        expirationDate: _expiryDate,
      );
      if (!mounted) return;
      setState(() => _editing = false);
      ref.invalidate(cabinetDetailProvider(widget.cabinetMedId));
      ref.invalidate(cabinetListProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Medication updated')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save: $e')));
    }
  }

  Future<void> _addToTreatments() async {
    final user = SupabaseService.auth.currentUser;
    if (user == null) return;

    try {
      final id = await CabinetService.instance.addToActiveTreatments(
        userId: user.id,
        medicationId: widget.initial.medication.medicationId,
        currentQuantity: widget.initial.cabinet.quantity,
        expiryDate: widget.initial.cabinet.expirationDate,
      );
      if (!mounted) return;
      ref.invalidate(treatmentsListProvider(TreatmentStatus.active));
      ref.invalidate(treatmentsListProvider(TreatmentStatus.completed));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to active treatments')),
      );
      context.push(AppRoutes.treatmentDetails(id));
    } on CabinetException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not add: $e')));
    }
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Delete medication?',
          style: Theme.of(
            ctx,
          ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          'This removes it from your cabinet only.',
          style: Theme.of(
            ctx,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error.withValues(alpha: 0.25),
              foregroundColor: AppColors.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    final user = SupabaseService.auth.currentUser;
    if (user == null) return;

    try {
      await CabinetService.instance.deleteCabinetEntry(
        widget.cabinetMedId,
        user.id,
      );
      if (!mounted) return;
      ref.invalidate(cabinetListProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Medication removed')));
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not delete: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Medication Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
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
                    AppColors.primary.withValues(alpha: 0.2),
                    AppColors.secondary.withValues(alpha: 0.12),
                  ],
                ),
                border: Border.all(color: AppColors.border),
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
                  )
                : Text(
                    widget.initial.medication.tradeNameEn,
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
                          '${_trimNum(widget.initial.medication.doseAmount)} ${widget.initial.medication.unit ?? ''}',
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
                  label: 'Quantity',
                  child: _editing
                      ? TextField(
                          controller: _qtyCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      : Text(
                          widget.initial.quantityLine,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'Expiration Date',
                  child: _editing
                      ? InkWell(
                          onTap: _pickExpiry,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 18,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _fmtYmd(_expiryDate),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        )
                      : Text(
                          _fmtYmd(widget.initial.cabinet.expirationDate),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                ),
              ),
            ],
          ),
          if (_editing) ...[
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('Save changes')),
          ],
          const SizedBox(height: 28),
          _GradientActionButton(
            icon: Icons.add_rounded,
            label: 'Add to Treatments',
            onPressed: _editing ? null : () => _addToTreatments(),
          ),
          const SizedBox(height: 12),
          _DeleteButton(onPressed: _confirmDelete),
        ],
      ),
    );
  }
}

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

class _GradientActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _GradientActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          height: 54,
          decoration: BoxDecoration(
            gradient: onPressed == null
                ? LinearGradient(
                    colors: [
                      AppColors.textDisabled.withValues(alpha: 0.3),
                      AppColors.textDisabled.withValues(alpha: 0.2),
                    ],
                  )
                : AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _DeleteButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Delete Medication',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
