import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/allergy_condition_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/router.dart';
import '../../../services/auth_service.dart';
import '../../../services/profile_service.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final l = AppLocalizations(locale);
    final isAr = l.isArabic;
    final profileAsync = ref.watch(userProfileProvider);

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(l.get('profile'))),
        body: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('${l.get('error')}: $e')),
          data: (profile) => _ProfileBody(profile: profile, l: l),
        ),
      ),
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  final UserModel? profile;
  final AppLocalizations l;

  const _ProfileBody({required this.profile, required this.l});

  bool get _isFemale =>
      profile?.gender.toLowerCase() == 'female';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = profile?.fullName ?? l.get('notSet');
    final initials = profile != null
        ? '${profile!.firstName[0]}${profile!.lastName[0]}'.toUpperCase()
        : '?';
        
    final isAr = l.isArabic;
    final allergiesAsync = ref.watch(allergiesConditionsProvider);
    final userAllergyIdsAsync = ref.watch(userAllergyConditionIdsProvider);
    
    String allergiesText = l.get('notSet');
    String conditionsText = l.get('notSet');

    if (allergiesAsync.isLoading || userAllergyIdsAsync.isLoading) {
      allergiesText = l.get('loading');
      conditionsText = l.get('loading');
    } else if (allergiesAsync.hasValue && userAllergyIdsAsync.hasValue) {
      final allItems = allergiesAsync.value!;
      final userIds = userAllergyIdsAsync.value!;
      
      final userItems = allItems.where((i) => userIds.contains(i.allergyConditionId)).toList();
      
      final allergies = userItems.where((i) => i.type == AllergyConditionType.allergy).map((i) => isAr ? (i.nameAr ?? i.name) : i.name).toList();
      final conditions = userItems.where((i) => i.type == AllergyConditionType.condition).map((i) => isAr ? (i.nameAr ?? i.name) : i.name).toList();

      if (allergies.isNotEmpty) allergiesText = allergies.join(', ');
      if (conditions.isNotEmpty) conditionsText = conditions.join(', ');
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.primary,
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                name,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            if (profile != null) ...[
              const SizedBox(height: 4),
              Center(
                child: Text(
                  '${l.get('gender')}: ${profile!.gender}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
            const SizedBox(height: 32),

            _SectionHeader(title: l.get('personalDetails')),
            _InfoCard(children: [
              _InfoRow(
                  label: l.get('firstName'),
                  value: profile?.firstName ?? l.get('notSet')),
              _InfoRow(
                  label: l.get('lastName'),
                  value: profile?.lastName ?? l.get('notSet')),
              _InfoRow(
                label: l.get('dateOfBirth'),
                value: profile != null
                    ? '${profile!.dob.day}/${profile!.dob.month}/${profile!.dob.year}'
                    : l.get('notSet'),
              ),
              _InfoRow(
                  label: l.get('gender'),
                  value: profile?.gender ?? l.get('notSet')),
            ]),
            const SizedBox(height: 8),
            _ProfileTile(
              icon: Icons.edit_outlined,
              label: l.get('editPersonalInfo'),
              onTap: () => _showEditPersonalInfo(context, ref),
            ),

            const SizedBox(height: 20),
            _SectionHeader(title: l.get('medicalDetails')),
            _InfoCard(children: [
              _InfoRow(
                label: l.get('bloodTypeLabel'),
                value: profile?.bloodType ?? l.get('notSet'),
              ),
              _InfoRow(
                label: l.get('weightLabel'),
                value: profile?.weightKg != null
                    ? '${profile!.weightKg} kg'
                    : l.get('notSet'),
              ),
              _InfoRow(
                label: l.get('smokerLabel'),
                value: profile?.smoker == true ? l.get('yes') : l.get('no'),
              ),
              if (_isFemale)
                _InfoRow(
                  label: l.get('pregnantLabel'),
                  value:
                      profile?.pregnant == true ? l.get('yes') : l.get('no'),
                ),
              _InfoRow(
                label: l.get('allergies'),
                value: allergiesText,
              ),
              _InfoRow(
                label: l.get('conditions'),
                value: conditionsText,
              ),
            ]),
            const SizedBox(height: 8),
            _ProfileTile(
              icon: Icons.edit_outlined,
              label: l.get('editMedicalRecord'),
              onTap: () => _showEditMedicalRecord(context, ref),
            ),

            const SizedBox(height: 20),
            _SectionHeader(title: l.get('reports')),
            _ProfileTile(
              icon: Icons.picture_as_pdf_outlined,
              label: l.get('generateReport'),
              onTap: () {},
            ),

            const SizedBox(height: 32),
            OutlinedButton.icon(
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: Text(
                l.get('signOut'),
                style: const TextStyle(color: AppColors.error),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
              ),
              onPressed: () => _confirmSignOut(context, ref),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _confirmSignOut(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.get('signOut')),
        content: Text(l.get('signOutConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.get('cancel')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(authServiceProvider).signOut();
              } catch (_) {}
              if (context.mounted) {
                context.go(AppRoutes.welcome);
              }
            },
            child: Text(
              l.get('signOut'),
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditPersonalInfo(BuildContext context, WidgetRef ref) {
    if (profile == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditPersonalInfoSheet(
        profile: profile!,
        l: l,
        onSaved: () => ref.invalidate(userProfileProvider),
      ),
    );
  }

  void _showEditMedicalRecord(BuildContext context, WidgetRef ref) {
    if (profile == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditMedicalRecordSheet(
        profile: profile!,
        l: l,
        onSaved: () {
          ref.invalidate(userProfileProvider);
          ref.invalidate(userAllergyConditionIdsProvider);
        },
      ),
    );
  }
}

// ── Edit Personal Info Bottom Sheet ──────────────────────────────────────────

class _EditPersonalInfoSheet extends StatefulWidget {
  final UserModel profile;
  final AppLocalizations l;
  final VoidCallback onSaved;

  const _EditPersonalInfoSheet({
    required this.profile,
    required this.l,
    required this.onSaved,
  });

  @override
  State<_EditPersonalInfoSheet> createState() => _EditPersonalInfoSheetState();
}

class _EditPersonalInfoSheetState extends State<_EditPersonalInfoSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late DateTime _dob;
  late String _gender;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.profile.firstName);
    _lastNameCtrl = TextEditingController(text: widget.profile.lastName);
    _dob = widget.profile.dob;
    _gender = widget.profile.gender;
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.l;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: const Border(top: BorderSide(color: AppColors.border)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(l.get('editPersonalInfo'),
                    style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _firstNameCtrl,
                  decoration: InputDecoration(
                    labelText: l.get('firstName'),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l.get('requiredField')
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _lastNameCtrl,
                  decoration: InputDecoration(
                    labelText: l.get('lastName'),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l.get('requiredField')
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration: InputDecoration(
                    labelText: l.get('gender'),
                    prefixIcon: const Icon(Icons.wc_outlined),
                  ),
                  items: [
                    DropdownMenuItem(
                        value: 'Male', child: Text(l.get('male'))),
                    DropdownMenuItem(
                        value: 'Female', child: Text(l.get('female'))),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _gender = v);
                  },
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickDob,
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: l.get('dateOfBirth'),
                        prefixIcon:
                            const Icon(Icons.calendar_today_outlined),
                      ),
                      controller: TextEditingController(
                        text: '${_dob.day}/${_dob.month}/${_dob.year}',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(l.get('saveChanges')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ProfileService.instance.updateProfile(widget.profile.userId, {
        'first_name': _firstNameCtrl.text.trim(),
        'last_name': _lastNameCtrl.text.trim(),
        'gender': _gender,
        'dob': _dob.toIso8601String().split('T').first,
      });
      widget.onSaved();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.l.get('profileUpdated'))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.l.get('error')}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

// ── Edit Medical Record Bottom Sheet ─────────────────────────────────────────

class _EditMedicalRecordSheet extends ConsumerStatefulWidget {
  final UserModel profile;
  final AppLocalizations l;
  final VoidCallback onSaved;

  const _EditMedicalRecordSheet({
    required this.profile,
    required this.l,
    required this.onSaved,
  });

  @override
  ConsumerState<_EditMedicalRecordSheet> createState() =>
      _EditMedicalRecordSheetState();
}

class _EditMedicalRecordSheetState
    extends ConsumerState<_EditMedicalRecordSheet> {
  late String? _bloodType;
  late final TextEditingController _weightCtrl;
  late bool _smoker;
  late bool _pregnant;
  final Set<String> _selectedAllergyIds = {};
  final Set<String> _selectedConditionIds = {};
  bool _saving = false;
  bool _loadedExisting = false;

  bool get _isFemale =>
      widget.profile.gender.toLowerCase() == 'female';

  static const _bloodTypes = [
    'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-',
  ];

  @override
  void initState() {
    super.initState();
    _bloodType = widget.profile.bloodType;
    _weightCtrl = TextEditingController(
        text: widget.profile.weightKg?.toString() ?? '');
    _smoker = widget.profile.smoker ?? false;
    _pregnant = widget.profile.pregnant ?? false;
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    super.dispose();
  }

  void _loadExistingSelections(List<AllergyConditionModel> allItems,
      List<String> existingIds) {
    if (_loadedExisting) return;
    _loadedExisting = true;

    for (final id in existingIds) {
      final item = allItems
          .where((i) => i.allergyConditionId == id)
          .firstOrNull;
      if (item == null) continue;
      if (item.type == AllergyConditionType.allergy) {
        _selectedAllergyIds.add(id);
      } else {
        _selectedConditionIds.add(id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.l;
    final isAr = l.isArabic;
    final allergiesAsync = ref.watch(allergiesConditionsProvider);
    final existingIdsAsync = ref.watch(userAllergyConditionIdsProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.95),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            border: const Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l.get('editMedicalRecord'),
                          style:
                              Theme.of(context).textTheme.displaySmall),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        initialValue: _bloodType,
                        decoration: InputDecoration(
                          labelText: l.get('bloodTypeLabel'),
                          prefixIcon:
                              const Icon(Icons.bloodtype_outlined),
                        ),
                        items: _bloodTypes
                            .map((t) => DropdownMenuItem(
                                value: t, child: Text(t)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _bloodType = v),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _weightCtrl,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                                decimal: true),
                        decoration: InputDecoration(
                          labelText: l.get('weightLabel'),
                          prefixIcon: const Icon(
                              Icons.monitor_weight_outlined),
                          suffixText: 'kg',
                        ),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: Text(l.get('smokerLabel')),
                        value: _smoker,
                        activeTrackColor: AppColors.primary,
                        onChanged: (v) =>
                            setState(() => _smoker = v),
                        contentPadding: EdgeInsets.zero,
                      ),
                      if (_isFemale)
                        SwitchListTile(
                          title: Text(l.get('pregnantLabel')),
                          value: _pregnant,
                          activeTrackColor: AppColors.primary,
                          onChanged: (v) =>
                              setState(() => _pregnant = v),
                          contentPadding: EdgeInsets.zero,
                        ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 12),

                      // Allergies & Conditions
                      allergiesAsync.when(
                        loading: () => const Center(
                            child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                              color: AppColors.primary),
                        )),
                        error: (e, _) => Text('Could not load: $e',
                            style:
                                const TextStyle(color: AppColors.error)),
                        data: (allItems) {
                          existingIdsAsync.whenData((ids) {
                            _loadExistingSelections(allItems, ids);
                          });

                          final allergies = allItems
                              .where((i) =>
                                  i.type ==
                                  AllergyConditionType.allergy)
                              .toList();
                          final conditions = allItems
                              .where((i) =>
                                  i.type ==
                                  AllergyConditionType.condition)
                              .toList();

                          return Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            children: [
                              _EditMultiSelectField(
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
                              ),
                              const SizedBox(height: 16),
                              _EditMultiSelectField(
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
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _saving ? null : _save,
                        child: _saving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white),
                              )
                            : Text(l.get('saveChanges')),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final profileService = ProfileService.instance;
      final userId = widget.profile.userId;

      await profileService.updateProfile(userId, {
        'blood_type': _bloodType,
        'weight_kg': double.tryParse(_weightCtrl.text),
        'smoker': _smoker,
        'pregnant': _isFemale ? _pregnant : false,
      });

      final allSelectedIds = {
        ..._selectedAllergyIds,
        ..._selectedConditionIds,
      };
      await profileService.setUserAllergiesAndConditions(
        userId,
        allSelectedIds.toList(),
      );

      widget.onSaved();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.l.get('profileUpdated'))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.l.get('error')}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

// ── Multi-select Field (for edit sheet) ──────────────────────────────────────

class _EditMultiSelectField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final List<AllergyConditionModel> items;
  final Set<String> selectedIds;
  final bool isArabic;
  final ValueChanged<Set<String>> onChanged;

  const _EditMultiSelectField({
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
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const Spacer(),
            if (selectedIds.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('${selectedIds.length}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ),
          ],
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            final result = await showModalBottomSheet<Set<String>>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => _EditMultiSelectSheet(
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedNames.isEmpty
                        ? hint
                        : selectedNames.join(', '),
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
        if (selectedNames.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: selectedNames.take(5).map((name) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Text(name,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.primary)),
              );
            }).toList()
              ..addAll(selectedNames.length > 5
                  ? [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('+${selectedNames.length - 5} more',
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary)),
                      ),
                    ]
                  : []),
          ),
        ],
      ],
    );
  }
}

class _EditMultiSelectSheet extends StatefulWidget {
  final String title;
  final List<AllergyConditionModel> items;
  final Set<String> selectedIds;
  final bool isArabic;

  const _EditMultiSelectSheet({
    required this.title,
    required this.items,
    required this.selectedIds,
    required this.isArabic,
  });

  @override
  State<_EditMultiSelectSheet> createState() => _EditMultiSelectSheetState();
}

class _EditMultiSelectSheetState extends State<_EditMultiSelectSheet> {
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
        .where((i) =>
            i.name.toLowerCase().contains(q) ||
            (i.nameAr?.contains(_searchQuery) ?? false))
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
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.95),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              border:
                  const Border(top: BorderSide(color: AppColors.border)),
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
                      Text(widget.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, _selected),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('Done',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: TextField(
                    onChanged: (v) =>
                        setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon:
                          const Icon(Icons.search, size: 20),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: AppColors.surfaceVariant
                          .withValues(alpha: 0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                if (_selected.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(20, 4, 20, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${_selected.length} selected',
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                const Divider(
                    height: 1, color: AppColors.divider),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: _filteredItems.length,
                    itemBuilder: (_, i) {
                      final item = _filteredItems[i];
                      final checked = _selected
                          .contains(item.allergyConditionId);
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
                            borderRadius:
                                BorderRadius.circular(8)),
                        onChanged: (v) {
                          setState(() {
                            if (v == true) {
                              _selected
                                  .add(item.allergyConditionId);
                            } else {
                              _selected.remove(
                                  item.allergyConditionId);
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

// ── Shared widgets ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<_InfoRow> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              children[i],
              if (i < children.length - 1) const Divider(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        trailing:
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}
