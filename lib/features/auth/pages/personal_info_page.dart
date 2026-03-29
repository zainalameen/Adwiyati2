import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/router.dart';
import '../widgets/auth_widgets.dart';

class PersonalInfoData {
  final String firstName;
  final String lastName;
  final String gender;
  final DateTime dob;

  const PersonalInfoData({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dob,
  });
}

class PersonalInfoPage extends ConsumerStatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  ConsumerState<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends ConsumerState<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  DateTime? _dob;
  String? _gender;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final l = AppLocalizations(locale);
    final isAr = l.isArabic;

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
                  const StepIndicator(currentStep: 1, totalSteps: 2),
                  const SizedBox(height: 24),
                  Text(
                    l.get('personalInfo'),
                    style: Theme.of(context).textTheme.displayLarge,
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.15),
                  const SizedBox(height: 6),
                  Text(
                    l.get('tellUsAboutYou'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 80.ms),
                  const SizedBox(height: 28),

                  GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _firstNameCtrl,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText: l.get('firstName'),
                                prefixIcon: const Icon(Icons.person_outline),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? l.get('requiredField')
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _lastNameCtrl,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText: l.get('lastName'),
                                prefixIcon: const Icon(Icons.person_outline),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? l.get('requiredField')
                                  : null,
                            ),
                            const SizedBox(height: 20),

                            Text(
                              l.get('gender'),
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _GenderChip(
                                    label: l.get('male'),
                                    icon: Icons.male_rounded,
                                    selected: _gender == 'Male',
                                    onTap: () =>
                                        setState(() => _gender = 'Male'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _GenderChip(
                                    label: l.get('female'),
                                    icon: Icons.female_rounded,
                                    selected: _gender == 'Female',
                                    onTap: () =>
                                        setState(() => _gender = 'Female'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            GestureDetector(
                              onTap: _pickDob,
                              child: AbsorbPointer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: l.get('dateOfBirth'),
                                    prefixIcon: const Icon(
                                      Icons.calendar_today_outlined,
                                    ),
                                    hintText: _dob == null
                                        ? l.get('selectDate')
                                        : '${_dob!.day}/${_dob!.month}/${_dob!.year}',
                                  ),
                                  validator: (_) => _dob == null
                                      ? l.get('requiredField')
                                      : null,
                                  controller: TextEditingController(
                                    text: _dob == null
                                        ? ''
                                        : '${_dob!.day}/${_dob!.month}/${_dob!.year}',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 150.ms)
                      .slideY(begin: 0.1),
                  const SizedBox(height: 40),

                  GradientButton(
                    label: l.get('continue_'),
                    onTap: _submit,
                  ).animate().fadeIn(duration: 400.ms, delay: 250.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(surface: AppColors.surface),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dob = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations(ref.read(localeProvider)).get('requiredField'),
          ),
        ),
      );
      return;
    }
    final data = PersonalInfoData(
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      gender: _gender!,
      dob: _dob!,
    );
    context.push(AppRoutes.medicalRecord, extra: data);
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _GenderChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
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
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
