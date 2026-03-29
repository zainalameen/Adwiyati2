import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lightweight localisation without code-generation.
/// Supports English (en) and Arabic (ar) per NFR9 / §4.1.4.
class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isArabic => locale.languageCode == 'ar';

  String get(String key) =>
      (_strings[locale.languageCode] ?? _strings['en']!)[key] ?? key;

  // ── String tables ─────────────────────────────────────────────────────

  static const Map<String, Map<String, String>> _strings = {
    'en': _en,
    'ar': _ar,
  };

  static const _en = <String, String>{
    // Welcome
    'appName': 'Adwiyati',
    'appTagline': 'All your medication needs',
    'createAccount': 'Create Account',
    'signIn': 'Sign In',
    'language': 'العربية',

    // Sign Up
    'getStarted': 'Create Account',
    'createYourAccount': 'Sign up to get started',
    'email': 'Email',
    'emailHint': 'Enter your email',
    'password': 'Password',
    'passwordHint': 'At least 8 characters',
    'confirmPassword': 'Confirm Password',
    'confirmPasswordHint': 'Re-enter password',
    'verificationHint': 'A verification link will be sent to your email',
    'alreadyHaveAccount': 'Already have an account?',

    // Login
    'welcomeBack': 'Welcome back',
    'signInToAccount': 'Log in to continue',
    'forgotPassword': 'Forgot Password?',
    'dontHaveAccount': "Don't have an account?",
    'signUp': 'Sign Up',

    // Forgot / Reset Password
    'resetYourPassword': 'Reset your password',
    'resetInstructions': 'Enter your email to reset your password',
    'sendResetLink': 'Send Reset Link',
    'resetPassword': 'Reset Password',
    'enterNewPassword': 'Enter your new password',
    'newPassword': 'New Password',
    'confirmNewPassword': 'Confirm Password',
    'updatePassword': 'Update Password',

    // Email verification
    'verifyEmail': 'Verify your email',
    'verifyMessage':
        'A confirmation link has been sent to your email address. '
        'Click it to continue.',
    'checkSpam': "If you don't see the email, check your spam folder.",
    'resendEmail': 'Resend Email',
    'backToSignIn': 'Back to Sign In',

    // Personal Info
    'personalInfo': 'Personal Information',
    'tellUsAboutYou': 'Tell us about yourself',
    'step1of2': 'Step 1 of 2 — Personal details',
    'firstName': 'First Name',
    'lastName': 'Last Name',
    'gender': 'Gender',
    'male': 'Male',
    'female': 'Female',
    'dateOfBirth': 'Date of Birth',
    'continue_': 'Continue',

    // Medical Record
    'medicalInfo': 'Medical Information',
    'medicalRecord': 'Medical Record',
    'medicalSubtitle': 'Help us understand your health',
    'bloodType': 'Blood Type',
    'weight': 'Weight (kg)',
    'smoker': 'Smoker',
    'pregnant': 'Pregnant',
    'allergiesAndConditions': 'Allergies & Chronic Conditions',
    'selectFromList': 'Select all that apply',
    'finishSetup': 'Complete Setup',
    'allergies': 'Allergies',
    'conditions': 'Chronic Conditions',

    // Validation
    'requiredField': 'This field is required',
    'invalidEmail': 'Enter a valid email',
    'passwordTooShort': 'Minimum 8 characters',
    'passwordsDontMatch': 'Passwords do not match',

    // Profile
    'profile': 'Profile',
    'editProfile': 'Edit Profile',
    'personalDetails': 'Personal Details',
    'medicalDetails': 'Medical Details',
    'reports': 'Reports',
    'generateReport': 'Generate Adherence Report',
    'signOut': 'Sign Out',
    'signOutConfirm': 'Are you sure you want to sign out?',
    'bloodTypeLabel': 'Blood Type',
    'weightLabel': 'Weight',
    'smokerLabel': 'Smoker',
    'pregnantLabel': 'Pregnant',
    'yes': 'Yes',
    'no': 'No',
    'notSet': 'Not set',
    'saveChanges': 'Save Changes',
    'profileUpdated': 'Profile updated successfully',
    'editPersonalInfo': 'Edit Personal Info',
    'editMedicalRecord': 'Edit Medical Record',

    // Misc
    'loading': 'Loading…',
    'error': 'Error',
    'ok': 'OK',
    'cancel': 'Cancel',
    'selectDate': 'Select date',
  };

  static const _ar = <String, String>{
    // Welcome
    'appName': 'أدويتي',
    'appTagline': 'كل احتياجاتك الدوائية',
    'createAccount': 'إنشاء حساب',
    'signIn': 'تسجيل الدخول',
    'language': 'English',

    // Sign Up
    'getStarted': 'إنشاء حساب',
    'createYourAccount': 'سجّل للبدء',
    'email': 'البريد الإلكتروني',
    'emailHint': 'أدخل بريدك الإلكتروني',
    'password': 'كلمة المرور',
    'passwordHint': '٨ أحرف على الأقل',
    'confirmPassword': 'تأكيد كلمة المرور',
    'confirmPasswordHint': 'أعد إدخال كلمة المرور',
    'verificationHint': 'سيتم إرسال رابط تحقق إلى بريدك الإلكتروني',
    'alreadyHaveAccount': 'لديك حساب بالفعل؟',

    // Login
    'welcomeBack': 'مرحبًا بعودتك',
    'signInToAccount': 'سجّل الدخول للمتابعة',
    'forgotPassword': 'نسيت كلمة المرور؟',
    'dontHaveAccount': 'ليس لديك حساب؟',
    'signUp': 'إنشاء حساب',

    // Forgot / Reset Password
    'resetYourPassword': 'إعادة تعيين كلمة المرور',
    'resetInstructions': 'أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور',
    'sendResetLink': 'إرسال رابط إعادة التعيين',
    'resetPassword': 'إعادة تعيين كلمة المرور',
    'enterNewPassword': 'أدخل كلمة المرور الجديدة',
    'newPassword': 'كلمة المرور الجديدة',
    'confirmNewPassword': 'تأكيد كلمة المرور',
    'updatePassword': 'تحديث كلمة المرور',

    // Email verification
    'verifyEmail': 'تحقق من بريدك الإلكتروني',
    'verifyMessage':
        'تم إرسال رابط تأكيد إلى بريدك الإلكتروني. اضغط عليه للمتابعة.',
    'checkSpam': 'إذا لم تجد البريد، تحقق من مجلد الرسائل غير المرغوب فيها.',
    'resendEmail': 'إعادة إرسال البريد',
    'backToSignIn': 'العودة إلى تسجيل الدخول',

    // Personal Info
    'personalInfo': 'المعلومات الشخصية',
    'tellUsAboutYou': 'حدّثنا عن نفسك',
    'step1of2': 'الخطوة ١ من ٢ — التفاصيل الشخصية',
    'firstName': 'الاسم الأول',
    'lastName': 'اسم العائلة',
    'gender': 'الجنس',
    'male': 'ذكر',
    'female': 'أنثى',
    'dateOfBirth': 'تاريخ الميلاد',
    'continue_': 'متابعة',

    // Medical Record
    'medicalInfo': 'المعلومات الطبية',
    'medicalRecord': 'السجل الطبي',
    'medicalSubtitle': 'ساعدنا لفهم صحتك',
    'bloodType': 'فصيلة الدم',
    'weight': 'الوزن (كغ)',
    'smoker': 'مدخّن',
    'pregnant': 'حامل',
    'allergiesAndConditions': 'الحساسيات والأمراض المزمنة',
    'selectFromList': 'اختر كل ما ينطبق',
    'finishSetup': 'إتمام الإعداد',
    'allergies': 'الحساسيات',
    'conditions': 'الأمراض المزمنة',

    // Validation
    'requiredField': 'هذا الحقل مطلوب',
    'invalidEmail': 'أدخل بريدًا إلكترونيًا صالحًا',
    'passwordTooShort': '٨ أحرف على الأقل',
    'passwordsDontMatch': 'كلمتا المرور غير متطابقتين',

    // Profile
    'profile': 'الملف الشخصي',
    'editProfile': 'تعديل الملف الشخصي',
    'personalDetails': 'التفاصيل الشخصية',
    'medicalDetails': 'التفاصيل الطبية',
    'reports': 'التقارير',
    'generateReport': 'إنشاء تقرير الالتزام',
    'signOut': 'تسجيل الخروج',
    'signOutConfirm': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
    'bloodTypeLabel': 'فصيلة الدم',
    'weightLabel': 'الوزن',
    'smokerLabel': 'مدخّن',
    'pregnantLabel': 'حامل',
    'yes': 'نعم',
    'no': 'لا',
    'notSet': 'غير محدد',
    'saveChanges': 'حفظ التغييرات',
    'profileUpdated': 'تم تحديث الملف الشخصي بنجاح',
    'editPersonalInfo': 'تعديل المعلومات الشخصية',
    'editMedicalRecord': 'تعديل السجل الطبي',

    // Misc
    'loading': 'جارٍ التحميل…',
    'error': 'خطأ',
    'ok': 'حسنًا',
    'cancel': 'إلغاء',
    'selectDate': 'اختر تاريخ',
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

// ── Riverpod locale state ──────────────────────────────────────────────────

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');

  void setLocale(Locale locale) => state = locale;

  void toggle() => state = state.languageCode == 'en'
      ? const Locale('ar')
      : const Locale('en');
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
