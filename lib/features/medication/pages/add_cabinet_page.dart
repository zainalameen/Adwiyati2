import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/router.dart';
import '../../../services/medication_management_service.dart';
import '../../../services/supabase_service.dart';

class AddCabinetPage extends StatefulWidget {
  const AddCabinetPage({super.key});

  @override
  State<AddCabinetPage> createState() => _AddCabinetPageState();
}

class _AddCabinetPageState extends State<AddCabinetPage> {
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

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  @override
  void dispose() {
    _doseCtrl.dispose();
    _quantityCtrl.dispose();
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
        title: const Text('Add to Cabinet'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _ProgressHeader(step: _step, totalSteps: 3),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: switch (_step) {
            1 => _buildStepOne(context),
            2 => _buildStepTwo(context),
            _ => _buildStepThree(context),
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
          onChanged: (value) {
            setState(() {
              _selectedMedication = value;
              if (value != null) {
                _selectedForm = _normalizeForm(value.dosageForm);
                _doseCtrl.text = '${value.doseAmount}${value.unit ?? ''}';
              }
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
          label: _loading ? 'Saving...' : 'Finish',
          onPressed: _loading ? null : _saveCabinetMedication,
        ),
      ],
    );
  }

  Future<void> _saveCabinetMedication() async {
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
      _showError('Please complete all required fields.');
      return;
    }

    setState(() => _loading = true);
    try {
      await MedicationManagementService.instance.createCabinetMedication(
        userId: user.id,
        medicationId: _selectedMedication!.id,
        quantity: quantity,
        expiryDate: _expiryDate!,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medication added to cabinet')),
      );
      context.pop();
    } catch (_) {
      _showError('Could not save cabinet medication.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
