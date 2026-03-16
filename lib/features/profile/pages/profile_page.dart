import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/router.dart';
import '../../../core/models/user_model.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = profile?.fullName ?? l.get('notSet');
    final initials = profile != null
        ? '${profile!.firstName[0]}${profile!.lastName[0]}'.toUpperCase()
        : '?';

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
              _InfoRow(
                label: l.get('pregnantLabel'),
                value:
                    profile?.pregnant == true ? l.get('yes') : l.get('no'),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _EditMedicalRecordSheet(
        profile: profile!,
        l: l,
        onSaved: () => ref.invalidate(userProfileProvider),
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
    return Padding(
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
                  color: AppColors.border,
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
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l.get('requiredField') : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastNameCtrl,
              decoration: InputDecoration(
                labelText: l.get('lastName'),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l.get('requiredField') : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _gender,
              decoration: InputDecoration(
                labelText: l.get('gender'),
                prefixIcon: const Icon(Icons.wc_outlined),
              ),
              items: [
                DropdownMenuItem(value: 'Male', child: Text(l.get('male'))),
                DropdownMenuItem(value: 'Female', child: Text(l.get('female'))),
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
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
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

class _EditMedicalRecordSheet extends StatefulWidget {
  final UserModel profile;
  final AppLocalizations l;
  final VoidCallback onSaved;

  const _EditMedicalRecordSheet({
    required this.profile,
    required this.l,
    required this.onSaved,
  });

  @override
  State<_EditMedicalRecordSheet> createState() =>
      _EditMedicalRecordSheetState();
}

class _EditMedicalRecordSheetState extends State<_EditMedicalRecordSheet> {
  late String? _bloodType;
  late final TextEditingController _weightCtrl;
  late bool _smoker;
  late bool _pregnant;
  bool _saving = false;

  static const _bloodTypes = [
    'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-',
  ];

  @override
  void initState() {
    super.initState();
    _bloodType = widget.profile.bloodType;
    _weightCtrl =
        TextEditingController(text: widget.profile.weightKg?.toString() ?? '');
    _smoker = widget.profile.smoker ?? false;
    _pregnant = widget.profile.pregnant ?? false;
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.l;
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(l.get('editMedicalRecord'),
              style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            initialValue: _bloodType,
            decoration: InputDecoration(
              labelText: l.get('bloodTypeLabel'),
              prefixIcon: const Icon(Icons.bloodtype_outlined),
            ),
            items: _bloodTypes
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => setState(() => _bloodType = v),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _weightCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l.get('weightLabel'),
              prefixIcon: const Icon(Icons.monitor_weight_outlined),
              suffixText: 'kg',
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: Text(l.get('smokerLabel')),
            value: _smoker,
            activeTrackColor: AppColors.primary,
            onChanged: (v) => setState(() => _smoker = v),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: Text(l.get('pregnantLabel')),
            value: _pregnant,
            activeTrackColor: AppColors.primary,
            onChanged: (v) => setState(() => _pregnant = v),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
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
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ProfileService.instance.updateProfile(widget.profile.userId, {
        'blood_type': _bloodType,
        'weight_kg': double.tryParse(_weightCtrl.text),
        'smoker': _smoker,
        'pregnant': _pregnant,
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
              if (i < children.length - 1)
                const Divider(height: 20),
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
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary)),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
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
