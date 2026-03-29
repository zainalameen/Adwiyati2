import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/allergy_condition_model.dart';
import '../../../core/router.dart';
import '../../../services/auth_service.dart';
import '../../../services/profile_service.dart';
import '../widgets/auth_widgets.dart';
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
  bool _pregnant = false;
  final Set<String> _selectedAllergyIds = {};
  final Set<String> _selectedConditionIds = {};
  bool _isSaving = false;
  String? _errorMessage;

  static const _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  PersonalInfoData? get _personalInfo {
    final extra = GoRouterState.of(context).extra;
    return extra is PersonalInfoData ? extra : null;
  }

  bool get _isFemale => _personalInfo?.gender.toLowerCase() == 'female';

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
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const StepIndicator(currentStep: 2, totalSteps: 2),
                  const SizedBox(height: 24),

                  Text(
                    l.get('medicalRecord'),
                    style: Theme.of(context).textTheme.displayLarge,
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.15),
                  const SizedBox(height: 6),
                  Text(
                    l.get('medicalSubtitle'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 80.ms),
                  const SizedBox(height: 28),

                  if (_errorMessage != null) ...[
                    AuthErrorBanner(message: _errorMessage!),
                    const SizedBox(height: 16),
                  ],

                  // Blood type
                  GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.bloodtype_outlined,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l.get('bloodType'),
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _BloodTypeGrid(
                              types: _bloodTypes,
                              selected: _bloodType,
                              onSelect: (v) => setState(() => _bloodType = v),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 150.ms)
                      .slideY(begin: 0.1),
                  const SizedBox(height: 16),

                  // Allergies & Conditions
                  allergiesAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    error: (e, _) => GlassCard(
                      child: Text(
                        'Could not load: $e',
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                    data: (items) {
                      final allergies = items
                          .where((i) => i.type == AllergyConditionType.allergy)
                          .toList();
                      final conditions = items
                          .where(
                            (i) => i.type == AllergyConditionType.condition,
                          )
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
                                onChanged: (ids) => setState(() {
                                  _selectedAllergyIds.clear();
                                  _selectedAllergyIds.addAll(ids);
                                }),
                              )
                              .animate()
                              .fadeIn(duration: 500.ms, delay: 250.ms)
                              .slideY(begin: 0.1),
                          const SizedBox(height: 16),
                          _MultiSelectDropdown(
                                label: l.get('conditions'),
                                hint: l.get('selectFromList'),
                                icon: Icons.favorite_outline,
                                items: conditions,
                                selectedIds: _selectedConditionIds,
                                isArabic: isAr,
                                onChanged: (ids) => setState(() {
                                  _selectedConditionIds.clear();
                                  _selectedConditionIds.addAll(ids);
                                }),
                              )
                              .animate()
                              .fadeIn(duration: 500.ms, delay: 350.ms)
                              .slideY(begin: 0.1),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Weight & Smoking
                  GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _weightCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: InputDecoration(
                                labelText: l.get('weight'),
                                prefixIcon: const Icon(
                                  Icons.monitor_weight_outlined,
                                ),
                                suffixText: 'kg',
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              l.get('smoker'),
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _ToggleChip(
                                    label: 'Yes',
                                    selected: _smoker,
                                    onTap: () => setState(() => _smoker = true),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _ToggleChip(
                                    label: 'No',
                                    selected: !_smoker,
                                    onTap: () =>
                                        setState(() => _smoker = false),
                                  ),
                                ),
                              ],
                            ),
                            if (_isFemale) ...[
                              const SizedBox(height: 20),
                              Text(
                                l.get('pregnant'),
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _ToggleChip(
                                      label: 'Yes',
                                      selected: _pregnant,
                                      onTap: () =>
                                          setState(() => _pregnant = true),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _ToggleChip(
                                      label: 'No',
                                      selected: !_pregnant,
                                      onTap: () =>
                                          setState(() => _pregnant = false),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 400.ms)
                      .slideY(begin: 0.1),
                  const SizedBox(height: 32),

                  GradientButton(
                    label: l.get('finishSetup'),
                    isLoading: _isSaving,
                    onTap: _submit,
                  ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
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
      setState(() => _errorMessage = 'Personal info missing. Please go back.');
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

      final allSelectedIds = {..._selectedAllergyIds, ..._selectedConditionIds};
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 68,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.primaryGradient : null,
              color: isSelected
                  ? null
                  : AppColors.surfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? null : Border.all(color: AppColors.border),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              type,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
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

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (selectedIds.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${selectedIds.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final result = await showModalBottomSheet<Set<String>>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
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
                color: AppColors.surfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(14),
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
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (selectedNames.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children:
                  selectedNames.take(5).map((name) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }).toList()..addAll(
                    selectedNames.length > 5
                        ? [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant.withValues(
                                  alpha: 0.3,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '+${selectedNames.length - 5} more',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ]
                        : [],
                  ),
            ),
          ],
        ],
      ),
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
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selectedIds);
  }

  List<AllergyConditionModel> get _filteredItems {
    if (_searchQuery.isEmpty) return widget.items;
    final q = _searchQuery.toLowerCase();
    return widget.items
        .where(
          (i) =>
              i.name.toLowerCase().contains(q) ||
              (i.nameAr?.contains(_searchQuery) ?? false),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      expand: false,
      builder: (_, controller) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: const Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, _selected),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceVariant.withValues(
                        alpha: 0.3,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                if (_selected.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${_selected.length} selected',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                const Divider(height: 1, color: AppColors.divider),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: _filteredItems.length,
                    itemBuilder: (_, index) {
                      final item = _filteredItems[index];
                      final checked = _selected.contains(
                        item.allergyConditionId,
                      );
                      return CheckboxListTile(
                        value: checked,
                        title: Text(
                          widget.isArabic
                              ? (item.nameAr ?? item.name)
                              : item.name,
                          style: TextStyle(
                            color: checked
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: checked
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        activeColor: AppColors.primary,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
          ),
        ),
      ),
    );
  }
}

// ── Toggle Chip ──────────────────────────────────────────────────────────────

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: selected ? AppColors.primaryGradient : null,
          color: selected
              ? null
              : AppColors.surfaceVariant.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(14),
          border: selected ? null : Border.all(color: AppColors.border),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
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
