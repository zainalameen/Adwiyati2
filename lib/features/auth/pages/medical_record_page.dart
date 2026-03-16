import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/allergy_condition_model.dart';
import '../../../core/router.dart';
import '../../../services/auth_service.dart';
import '../../../services/profile_service.dart';
import 'personal_info_page.dart';

class MedicalRecordPage extends ConsumerStatefulWidget {
  const MedicalRecordPage({super.key});

  @override
  ConsumerState<MedicalRecordPage> createState() => _MedicalRecordPageState();
}

class _MedicalRecordPageState extends ConsumerState<MedicalRecordPage> {
  final _formKey = GlobalKey<FormState>();
  String? _bloodType;
  final _weightCtrl = TextEditingController();
  bool _smoker = false;
  final bool _pregnant = false;
  final Set<String> _selectedAllergyIds = {};
  final Set<String> _selectedConditionIds = {};
  bool _isSaving = false;
  String? _errorMessage;

  static const _bloodTypes = [
    'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-',
  ];

  PersonalInfoData? get _personalInfo {
    final extra = GoRouterState.of(context).extra;
    return extra is PersonalInfoData ? extra : null;
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final l = AppLocalizations(locale);
    final isAr = l.isArabic;
    final allergiesAsync = ref.watch(allergiesConditionsProvider);

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _StepIndicator(currentStep: 2, totalSteps: 2),
                  const SizedBox(height: 24),

                  Text(l.get('medicalRecord'),
                      style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(height: 6),
                  Text(l.get('medicalSubtitle'),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 28),

                  if (_errorMessage != null) ...[
                    _ErrorBanner(message: _errorMessage!),
                    const SizedBox(height: 16),
                  ],

                  // Blood type grid
                  Text(l.get('bloodType'),
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  _BloodTypeGrid(
                    types: _bloodTypes,
                    selected: _bloodType,
                    onSelect: (v) => setState(() => _bloodType = v),
                  ),
                  const SizedBox(height: 20),

                  // Allergies dropdown
                  allergiesAsync.when(
                    loading: () => const Center(
                        child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    )),
                    error: (e, _) => Text('Could not load: $e'),
                    data: (items) {
                      final allergies = items
                          .where(
                              (i) => i.type == AllergyConditionType.allergy)
                          .toList();
                      final conditions = items
                          .where(
                              (i) => i.type == AllergyConditionType.condition)
                          .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _MultiSelectDropdown(
                            label: l.get('allergies'),
                            hint: l.get('selectFromList'),
                            icon: Icons.warning_amber_outlined,
                            items: allergies,
                            selectedIds: _selectedAllergyIds,
                            isArabic: isAr,
                            onChanged: (ids) =>
                                setState(() {
                                  _selectedAllergyIds.clear();
                                  _selectedAllergyIds.addAll(ids);
                                }),
                          ),
                          const SizedBox(height: 16),
                          _MultiSelectDropdown(
                            label: l.get('conditions'),
                            hint: l.get('selectFromList'),
                            icon: Icons.favorite_outline,
                            items: conditions,
                            selectedIds: _selectedConditionIds,
                            isArabic: isAr,
                            onChanged: (ids) =>
                                setState(() {
                                  _selectedConditionIds.clear();
                                  _selectedConditionIds.addAll(ids);
                                }),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Weight
                  TextFormField(
                    controller: _weightCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: l.get('weight'),
                      prefixIcon: const Icon(Icons.monitor_weight_outlined),
                      suffixText: 'kg',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Smoking status
                  Text(l.get('smoker'),
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _ToggleButton(
                          label: 'Yes',
                          selected: _smoker,
                          onTap: () => setState(() => _smoker = true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ToggleButton(
                          label: 'No',
                          selected: !_smoker,
                          onTap: () => setState(() => _smoker = false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: _isSaving ? null : _submit,
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(l.get('finishSetup')),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final info = _personalInfo;
    if (info == null) {
      setState(
          () => _errorMessage = 'Personal info missing. Please go back.');
      return;
    }

    final userId = ref.read(authServiceProvider).currentUser?.id;
    if (userId == null) {
      setState(() => _errorMessage = 'Not authenticated.');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final profileService = ref.read(profileServiceProvider);

      await profileService.createProfile(
        userId: userId,
        firstName: info.firstName,
        lastName: info.lastName,
        dob: info.dob,
        gender: info.gender,
        bloodType: _bloodType,
        weightKg: double.tryParse(_weightCtrl.text),
        smoker: _smoker,
        pregnant: _pregnant,
      );

      final allSelectedIds = {
        ..._selectedAllergyIds,
        ..._selectedConditionIds,
      };
      if (allSelectedIds.isNotEmpty) {
        await profileService.setUserAllergiesAndConditions(
          userId,
          allSelectedIds.toList(),
        );
      }

      if (!mounted) return;
      ref.invalidate(userProfileProvider);
      context.go(AppRoutes.home);
    } catch (e) {
      setState(() => _errorMessage = 'Failed to save profile: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

// ── Blood Type Grid ──────────────────────────────────────────────────────────

class _BloodTypeGrid extends StatelessWidget {
  final List<String> types;
  final String? selected;
  final ValueChanged<String> onSelect;

  const _BloodTypeGrid({
    required this.types,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((type) {
        final isSelected = type == selected;
        return GestureDetector(
          onTap: () => onSelect(type),
          child: Container(
            width: 68,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Multi-select Dropdown ────────────────────────────────────────────────────

class _MultiSelectDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final List<AllergyConditionModel> items;
  final Set<String> selectedIds;
  final bool isArabic;
  final ValueChanged<Set<String>> onChanged;

  const _MultiSelectDropdown({
    required this.label,
    required this.hint,
    required this.icon,
    required this.items,
    required this.selectedIds,
    required this.isArabic,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedNames = items
        .where((i) => selectedIds.contains(i.allergyConditionId))
        .map((i) => isArabic ? (i.nameAr ?? i.name) : i.name)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(label, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final result = await showModalBottomSheet<Set<String>>(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => _MultiSelectSheet(
                title: label,
                items: items,
                selectedIds: Set.from(selectedIds),
                isArabic: isArabic,
              ),
            );
            if (result != null) onChanged(result);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedNames.isEmpty ? hint : selectedNames.join(', '),
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedNames.isEmpty
                          ? AppColors.textDisabled
                          : AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MultiSelectSheet extends StatefulWidget {
  final String title;
  final List<AllergyConditionModel> items;
  final Set<String> selectedIds;
  final bool isArabic;

  const _MultiSelectSheet({
    required this.title,
    required this.items,
    required this.selectedIds,
    required this.isArabic,
  });

  @override
  State<_MultiSelectSheet> createState() => _MultiSelectSheetState();
}

class _MultiSelectSheetState extends State<_MultiSelectSheet> {
  late final Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.8,
      minChildSize: 0.3,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title,
                    style: Theme.of(context).textTheme.displaySmall),
                TextButton(
                  onPressed: () => Navigator.pop(context, _selected),
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: widget.items.length,
              itemBuilder: (_, i) {
                final item = widget.items[i];
                final checked =
                    _selected.contains(item.allergyConditionId);
                return CheckboxListTile(
                  value: checked,
                  title: Text(widget.isArabic
                      ? (item.nameAr ?? item.name)
                      : item.name),
                  activeColor: AppColors.primary,
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        _selected.add(item.allergyConditionId);
                      } else {
                        _selected.remove(item.allergyConditionId);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Toggle Button ────────────────────────────────────────────────────────────

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

// ── Shared widgets ───────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepIndicator({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final isActive = i < currentStep;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: i < totalSteps - 1 ? 8 : 0),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
