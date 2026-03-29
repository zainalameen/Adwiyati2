import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/router.dart';
import '../../../services/medication_management_service.dart';
import '../../../services/supabase_service.dart';

enum _DurationMode { endDate, ongoing, specificQuantity }

class AddTreatmentPage extends StatefulWidget {
  const AddTreatmentPage({super.key});

  @override
  State<AddTreatmentPage> createState() => _AddTreatmentPageState();
}

class _AddTreatmentPageState extends State<AddTreatmentPage> {
  int _step = 1;
  bool _loading = false;
  bool _scanSelected = true;

  List<MedicationOption> _medications = [];
  List<String> _dosageForms = const [];
  MedicationOption? _selectedMedication;
  String? _selectedForm;
  final _doseCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  DateTime? _expiryDate;

  String? _selectedPurpose;
  final _purposes = const [
    'Headache',
    'Fever',
    'Allergy',
    'Infection',
    'General',
  ];
  _DurationMode _durationMode = _DurationMode.endDate;
  DateTime? _endDate;
  final _specificQtyCtrl = TextEditingController();
  final List<_ReminderDraft> _reminders = [const _ReminderDraft()];

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  @override
  void dispose() {
    _doseCtrl.dispose();
    _quantityCtrl.dispose();
    _specificQtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadMedications() async {
    final meds = await MedicationManagementService.instance
        .fetchMedicationOptions();
    if (!mounted) return;
    final forms = meds.map((m) => _normalizeForm(m.dosageForm)).toSet().toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    setState(() {
      _medications = meds;
      _dosageForms = forms;
      _selectedForm = forms.isNotEmpty ? forms.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text('Add Treatment'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _ProgressHeader(step: _step, totalSteps: 4),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: switch (_step) {
            1 => _buildStepOne(context),
            2 => _buildStepTwo(context),
            3 => _buildStepThree(context),
            _ => _buildStepFour(context),
          },
        ),
      ),
    );
  }

  Widget _buildStepOne(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How do you want to add?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        _ChoiceButton(
          label: 'Scan medication',
          selected: _scanSelected,
          gradient: true,
          onTap: () => setState(() => _scanSelected = true),
        ),
        const SizedBox(height: 12),
        _ChoiceButton(
          label: 'Enter manually',
          selected: !_scanSelected,
          onTap: () => setState(() => _scanSelected = false),
        ),
        const SizedBox(height: 24),
        _PrimaryButton(
          label: 'Next',
          onPressed: () async {
            if (_scanSelected) {
              if (mounted) context.go(AppRoutes.scan);
              return;
            }
            setState(() => _step = 2);
          },
        ),
      ],
    );
  }

  Widget _buildStepTwo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Medication Information',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        const Text('Medication Name'),
        const SizedBox(height: 8),
        DropdownButtonFormField<MedicationOption>(
          value: _selectedMedication,
          items: _medications
              .map(
                (m) => DropdownMenuItem(value: m, child: Text(m.tradeNameEn)),
              )
              .toList(),
          onChanged: (value) async {
            if (value == null) return;
            final user = SupabaseService.auth.currentUser;

            bool proceed = true;
            if (user != null) {
              final hasInteraction = await MedicationManagementService.instance
                  .hasPotentialInteraction(
                    userId: user.id,
                    medicationId: value.id,
                  );
              if (hasInteraction && mounted) {
                proceed = await _showInteractionWarning() ?? false;
              }
            }

            if (!proceed || !mounted) return;
            setState(() {
              _selectedMedication = value;
              _selectedForm = _normalizeForm(value.dosageForm);
              _doseCtrl.text = '${value.doseAmount}${value.unit ?? ''}';
            });
          },
          decoration: const InputDecoration(
            hintText: 'Medication Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Form'),
        const SizedBox(height: 8),
        if (_dosageForms.isEmpty)
          Text(
            'No dosage forms available',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _dosageForms
                .map(
                  (f) => ChoiceChip(
                    label: Text(f),
                    selected: _selectedForm == f,
                    onSelected: (_) => setState(() => _selectedForm = f),
                  ),
                )
                .toList(),
          ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _doseCtrl,
          decoration: const InputDecoration(
            labelText: 'Dose Amount & Unit',
            hintText: 'e.g., 500mg',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        _PrimaryButton(
          label: 'Next',
          onPressed: () {
            if (_selectedMedication == null) {
              _showError('Please select a medication.');
              return;
            }
            setState(() => _step = 3);
          },
        ),
      ],
    );
  }

  Widget _buildStepThree(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity & Expiration Date',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _quantityCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Quantity',
            hintText: 'Enter quantity',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              initialDate: _expiryDate ?? DateTime.now(),
            );
            if (picked != null) {
              setState(() => _expiryDate = picked);
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Expiration Date',
              border: OutlineInputBorder(),
            ),
            child: Text(
              _expiryDate == null ? 'dd/mm/yyyy' : _fmtDate(_expiryDate!),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _PrimaryButton(
          label: 'Next',
          onPressed: () {
            final quantity = double.tryParse(_quantityCtrl.text.trim());
            if (quantity == null || quantity <= 0 || _expiryDate == null) {
              _showError('Please complete quantity and expiration date.');
              return;
            }
            setState(() => _step = 4);
          },
        ),
      ],
    );
  }

  Widget _buildStepFour(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Purpose of Use & Dose Reminders',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        const Text('Purpose of Use'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedPurpose,
          items: _purposes
              .map((p) => DropdownMenuItem(value: p, child: Text(p)))
              .toList(),
          onChanged: (value) => setState(() => _selectedPurpose = value),
          decoration: const InputDecoration(
            hintText: 'Select purpose',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Treatment Duration'),
        const SizedBox(height: 8),
        _radioTile('End Date', _DurationMode.endDate),
        _radioTile('Ongoing Treatment', _DurationMode.ongoing),
        _radioTile('Specific Quantity', _DurationMode.specificQuantity),
        if (_durationMode == _DurationMode.endDate) ...[
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                initialDate: _endDate ?? DateTime.now(),
              );
              if (picked != null) {
                setState(() => _endDate = picked);
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'End Date',
                border: OutlineInputBorder(),
              ),
              child: Text(
                _endDate == null ? 'dd/mm/yyyy' : _fmtDate(_endDate!),
              ),
            ),
          ),
        ],
        if (_durationMode == _DurationMode.specificQuantity) ...[
          const SizedBox(height: 8),
          TextFormField(
            controller: _specificQtyCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Total Quantity',
              hintText: 'e.g., 30 doses',
              border: OutlineInputBorder(),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('Dose Reminders'),
            const Spacer(),
            TextButton.icon(
              onPressed: () =>
                  setState(() => _reminders.add(const _ReminderDraft())),
              icon: const Icon(Icons.add),
              label: const Text('Add Reminder'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...List.generate(
          _reminders.length,
          (i) => _ReminderEditor(
            key: ValueKey('reminder_$i'),
            index: i,
            reminder: _reminders[i],
            onChanged: (updated) => _reminders[i] = updated,
            onRemove: _reminders.length == 1
                ? null
                : () => setState(() => _reminders.removeAt(i)),
          ),
        ),
        const SizedBox(height: 24),
        _PrimaryButton(
          label: _loading ? 'Saving...' : 'Finish',
          onPressed: _loading ? null : _saveTreatment,
        ),
      ],
    );
  }

  Widget _radioTile(String label, _DurationMode value) {
    return InkWell(
      onTap: () => setState(() => _durationMode = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: _durationMode == value
                ? AppColors.primary
                : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              _durationMode == value
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: _durationMode == value
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTreatment() async {
    final user = SupabaseService.auth.currentUser;
    final quantity = double.tryParse(_quantityCtrl.text.trim());

    if (user == null) {
      _showError('Session expired. Please login again.');
      return;
    }
    if (_selectedMedication == null ||
        quantity == null ||
        quantity <= 0 ||
        _expiryDate == null) {
      _showError('Please complete required fields.');
      return;
    }
    if (_selectedPurpose == null) {
      _showError('Please select purpose of use.');
      return;
    }
    if (_durationMode == _DurationMode.endDate && _endDate == null) {
      _showError('Please select end date.');
      return;
    }

    final specificQty = _durationMode == _DurationMode.specificQuantity
        ? int.tryParse(_specificQtyCtrl.text.trim())
        : null;
    if (_durationMode == _DurationMode.specificQuantity &&
        (specificQty == null || specificQty <= 0)) {
      _showError('Please enter a valid specific quantity.');
      return;
    }

    final hasInvalidReminder = _reminders.any((r) => r.quantityPerDose <= 0);
    if (hasInvalidReminder) {
      _showError('Each reminder must have quantity per dose.');
      return;
    }

    setState(() => _loading = true);
    try {
      await MedicationManagementService.instance.createActiveTreatment(
        userId: user.id,
        medicationId: _selectedMedication!.id,
        currentQuantity: quantity,
        expiryDate: _expiryDate!,
        endDate: _durationMode == _DurationMode.endDate ? _endDate : null,
        pillsToTake: specificQty,
        reminders: _reminders
            .map(
              (r) => ReminderInput(
                time: r.time,
                frequency: r.frequency,
                quantityPerDose: r.quantityPerDose,
              ),
            )
            .toList(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Treatment created')));
      context.pop();
    } catch (_) {
      _showError('Could not create treatment.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<bool?> _showInteractionWarning() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Drug Interaction Warning'),
        content: const Text(
          'This medication may interact with your current medications. '
          'Please consult your doctor before proceeding.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Proceed Anyway'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _normalizeForm(String form) {
    final value = form.trim();
    if (value.isEmpty) return 'Unknown';
    final lower = value.toLowerCase();
    if (lower.length == 1) return lower.toUpperCase();
    return '${lower[0].toUpperCase()}${lower.substring(1)}';
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

class _ReminderDraft {
  final TimeOfDay time;
  final String frequency;
  final double quantityPerDose;

  const _ReminderDraft({
    this.time = const TimeOfDay(hour: 8, minute: 0),
    this.frequency = 'Daily',
    this.quantityPerDose = 1,
  });

  _ReminderDraft copyWith({
    TimeOfDay? time,
    String? frequency,
    double? quantityPerDose,
  }) {
    return _ReminderDraft(
      time: time ?? this.time,
      frequency: frequency ?? this.frequency,
      quantityPerDose: quantityPerDose ?? this.quantityPerDose,
    );
  }
}

class _ReminderEditor extends StatefulWidget {
  const _ReminderEditor({
    super.key,
    required this.index,
    required this.reminder,
    required this.onChanged,
    this.onRemove,
  });

  final int index;
  final _ReminderDraft reminder;
  final ValueChanged<_ReminderDraft> onChanged;
  final VoidCallback? onRemove;

  @override
  State<_ReminderEditor> createState() => _ReminderEditorState();
}

class _ReminderEditorState extends State<_ReminderEditor> {
  late final TextEditingController _qtyCtrl;

  @override
  void initState() {
    super.initState();
    _qtyCtrl = TextEditingController(
      text: widget.reminder.quantityPerDose.toString(),
    );
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Reminder ${widget.index + 1}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (widget.onRemove != null)
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: widget.reminder.time,
              );
              if (picked != null) {
                widget.onChanged(widget.reminder.copyWith(time: picked));
                setState(() {});
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
              child: Text(widget.reminder.time.format(context)),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: widget.reminder.frequency,
            items: const [
              DropdownMenuItem(value: 'Daily', child: Text('Daily')),
              DropdownMenuItem(
                value: 'Every 2 Days',
                child: Text('Every 2 Days'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              widget.onChanged(widget.reminder.copyWith(frequency: value));
            },
            decoration: const InputDecoration(
              labelText: 'Frequency',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _qtyCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Quantity per dose',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              final parsed = double.tryParse(value.trim());
              widget.onChanged(
                widget.reminder.copyWith(quantityPerDose: parsed ?? 0),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.step, required this.totalSteps});

  final int step;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Text(
              'Step $step of $totalSteps',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: step / totalSteps,
          minHeight: 4,
          backgroundColor: AppColors.surfaceVariant,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ],
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.selected,
    required this.onTap,
    this.gradient = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool gradient;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        height: 52,
        decoration: BoxDecoration(
          gradient: selected && gradient ? AppColors.primaryGradient : null,
          color: selected && !gradient
              ? AppColors.surfaceVariant
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected && gradient
                  ? Colors.white
                  : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed != null ? AppColors.primaryGradient : null,
          color: onPressed == null ? AppColors.surfaceVariant : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
