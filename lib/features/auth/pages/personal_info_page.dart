import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/router.dart';

/// Holds personal-info data that gets passed to the medical-record step.
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
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Step indicator
                  _StepIndicator(currentStep: 1, totalSteps: 2),
                  const SizedBox(height: 24),

                  Text(l.get('personalInfo'),
                      style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(height: 6),
                  Text(l.get('tellUsAboutYou'),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 28),

                  // First Name
                  TextFormField(
                    controller: _firstNameCtrl,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: l.get('firstName'),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? l.get('requiredField') : null,
                  ),
                  const SizedBox(height: 16),

                  // Last Name
                  TextFormField(
                    controller: _lastNameCtrl,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: l.get('lastName'),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? l.get('requiredField') : null,
                  ),
                  const SizedBox(height: 16),

                  // Gender toggle
                  Text(l.get('gender'),
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _gender = 'Male'),
                          child: Container(
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _gender == 'Male'
                                  ? AppColors.primary
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _gender == 'Male'
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(
                              l.get('male'),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _gender == 'Male'
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _gender = 'Female'),
                          child: Container(
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _gender == 'Female'
                                  ? AppColors.primary
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _gender == 'Female'
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(
                              l.get('female'),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _gender == 'Female'
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Date of Birth
                  GestureDetector(
                    onTap: _pickDob,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: l.get('dateOfBirth'),
                          prefixIcon:
                              const Icon(Icons.calendar_today_outlined),
                          hintText: _dob == null
                              ? l.get('selectDate')
                              : '${_dob!.day}/${_dob!.month}/${_dob!.year}',
                        ),
                        validator: (_) =>
                            _dob == null ? l.get('requiredField') : null,
                        controller: TextEditingController(
                          text: _dob == null
                              ? ''
                              : '${_dob!.day}/${_dob!.month}/${_dob!.year}',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(l.get('continue_')),
                  ),
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
    );
    if (picked != null) setState(() => _dob = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations(ref.read(localeProvider)).get('requiredField'))),
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
