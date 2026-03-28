import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth/pages/welcome_page.dart';
import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/signup_page.dart';
import '../features/auth/pages/verify_page.dart';
import '../features/auth/pages/forgot_password_page.dart';
import '../features/auth/pages/reset_password_page.dart';
import '../features/auth/pages/personal_info_page.dart';
import '../features/auth/pages/medical_record_page.dart';
import '../features/home/pages/home_page.dart';
import '../features/home/pages/progress_page.dart';
import '../features/chatbot/pages/chatbot_page.dart';
import '../features/scanner/pages/scanner_page.dart';
import '../features/treatments/pages/treatment_details_page.dart';
import '../features/treatments/pages/treatments_page.dart';
import '../features/cabinet/pages/cabinet_medication_details_page.dart';
import '../features/cabinet/pages/cabinet_page.dart';
import '../features/profile/pages/profile_page.dart';
import '../shared/widgets/main_scaffold.dart';
import 'models/user_model.dart';
import '../services/profile_service.dart';
import '../services/supabase_service.dart';

/// Named route constants.
abstract final class AppRoutes {
  static const welcome = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const verify = '/verify';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const personalInfo = '/personal-info';
  static const medicalRecord = '/medical-record';

  static const home = '/home';
  static const chatbot = '/chatbot';
  static const scan = '/scan';
  static const treatments = '/treatments';
  static const cabinet = '/cabinet';

  static const profile = '/profile';
  static const progress = '/progress';

  /// Full-screen treatment editor (outside bottom shell).
  static String treatmentDetails(String treatmentId) =>
      '/treatment-details/$treatmentId';

  /// Cabinet medication details (outside bottom shell).
  static String cabinetMedicationDetails(String cabinetMedId) =>
      '/cabinet-med/$cabinetMedId';

  /// Routes that do NOT require authentication.
  static const publicRoutes = {
    welcome,
    login,
    signup,
    verify,
    forgotPassword,
    resetPassword,
  };

  /// Routes that are part of the onboarding profile-creation flow.
  static const onboardingRoutes = {
    personalInfo,
    medicalRecord,
  };
}

/// Creates the router. Accepts a [Ref] so it can check auth state.
GoRouter createRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.welcome,
    debugLogDiagnostics: true,
    refreshListenable: _GoRouterAuthNotifier(ref),
    redirect: (context, state) =>
        _authRedirect(ref, _normalizeMatchedLocation(state.matchedLocation)),
    routes: [
      // ── Auth flow ──────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: AppRoutes.verify,
        name: 'verify',
        builder: (context, state) => const VerifyPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'resetPassword',
        builder: (context, state) => const ResetPasswordPage(),
      ),

      // ── Onboarding (health profile creation) ───────────────────────────
      GoRoute(
        path: AppRoutes.personalInfo,
        name: 'personalInfo',
        builder: (context, state) => const PersonalInfoPage(),
      ),
      GoRoute(
        path: AppRoutes.medicalRecord,
        name: 'medicalRecord',
        builder: (context, state) => const MedicalRecordPage(),
      ),

      // ── Profile (top nav) ──────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),

      // ── Progress (gamification details) ─────────────────────────────────
      GoRoute(
        path: AppRoutes.progress,
        name: 'progress',
        builder: (context, state) => const ProgressPage(),
      ),

      GoRoute(
        path: '/treatment-details/:treatmentId',
        name: 'treatmentDetails',
        builder: (context, state) => TreatmentDetailsPage(
          treatmentId: state.pathParameters['treatmentId']!,
        ),
      ),

      GoRoute(
        path: '/cabinet-med/:cabinetMedId',
        name: 'cabinetMedicationDetails',
        builder: (context, state) => CabinetMedicationDetailsPage(
          cabinetMedId: state.pathParameters['cabinetMedId']!,
        ),
      ),

      // ── Core shell — 5 bottom-nav screens ──────────────────────────────
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.chatbot,
            name: 'chatbot',
            builder: (context, state) => const ChatbotPage(),
          ),
          GoRoute(
            path: AppRoutes.scan,
            name: 'scan',
            builder: (context, state) => const ScannerPage(),
          ),
          GoRoute(
            path: AppRoutes.treatments,
            name: 'treatments',
            builder: (context, state) => const TreatmentsPage(),
          ),
          GoRoute(
            path: AppRoutes.cabinet,
            name: 'cabinet',
            builder: (context, state) => const CabinetPage(),
          ),
        ],
      ),
    ],
  );
}

// ── Auth redirect logic ──────────────────────────────────────────────────

/// GoRouter passes [GoRouterState.matchedLocation] as [Uri.path]. On web the root
/// URL can yield `''` instead of `'/'`, which would not match [AppRoutes.publicRoutes].
String _normalizeMatchedLocation(String location) =>
    location.isEmpty ? '/' : location;

bool _isPasswordRecovery = false;

void clearPasswordRecoveryFlag() {
  _isPasswordRecovery = false;
}

Future<String?> _authRedirect(Ref ref, String location) async {
  final session = SupabaseService.auth.currentSession;
  final isLoggedIn = session != null;
  final isPublic = AppRoutes.publicRoutes.contains(location);
  final isOnboarding = AppRoutes.onboardingRoutes.contains(location);

  if (_isPasswordRecovery) {
    if (location == AppRoutes.resetPassword) return null;
    return AppRoutes.resetPassword;
  }

  if (!isLoggedIn && !isPublic) {
    return AppRoutes.welcome;
  }

  if (isLoggedIn && isPublic) {
    final profile = await _getProfileForRedirect(session.user.id);
    return profile == null ? AppRoutes.personalInfo : AppRoutes.home;
  }

  if (isLoggedIn && !isOnboarding && !isPublic) {
    final profile = await _getProfileForRedirect(session.user.id);
    if (profile == null) return AppRoutes.personalInfo;
  }

  return null;
}

/// Used only from [GoRouter.redirect]. Avoids an indefinite white screen when
/// Supabase is misconfigured or the network never completes.
Future<UserModel?> _getProfileForRedirect(String userId) async {
  try {
    return await ProfileService.instance
        .getProfile(userId)
        .timeout(const Duration(seconds: 15));
  } on Object catch (e, st) {
    debugPrint('Auth redirect: profile fetch failed: $e');
    debugPrint('$st');
    return null;
  }
}

// ── Listenable that triggers GoRouter refresh on auth changes ────────────

class _GoRouterAuthNotifier extends ChangeNotifier {
  late final StreamSubscription<AuthState> _sub;

  _GoRouterAuthNotifier(Ref ref) {
    _sub = SupabaseService.auth.onAuthStateChange.listen((authState) {
      if (authState.event == AuthChangeEvent.passwordRecovery) {
        _isPasswordRecovery = true;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

// ── Riverpod provider for the router ─────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) => createRouter(ref));
