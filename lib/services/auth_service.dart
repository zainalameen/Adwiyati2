import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

/// Typed wrapper around Supabase Auth covering FR1, FR5–FR8.
class AuthService {
  AuthService._();
  static final instance = AuthService._();

  GoTrueClient get _auth => SupabaseService.auth;

  // ── Current state ────────────────────────────────────────────────────────

  Session? get currentSession => _auth.currentSession;
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => currentSession != null;

  /// Real-time stream of auth state changes.
  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;

  // ── FR1 — Sign up ───────────────────────────────────────────────────────

  /// Creates a new account. Supabase will send a confirmation email.
  /// Throws [AuthServiceException] on failure.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _auth.signUp(email: email, password: password);

      // Supabase returns a user with empty identities when the email is
      // already registered (to prevent enumeration). Detect that case.
      if (res.user != null &&
          (res.user!.identities == null || res.user!.identities!.isEmpty)) {
        throw AuthServiceException(
            'An account with this email already exists.');
      }

      return res;
    } on AuthServiceException {
      rethrow;
    } on AuthException catch (e) {
      throw AuthServiceException(_mapAuthError(e));
    }
  }

  // ── FR6 — Log in ────────────────────────────────────────────────────────

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      return res;
    } on AuthException catch (e) {
      throw AuthServiceException(_mapAuthError(e));
    }
  }

  // ── FR7 — Log out ───────────────────────────────────────────────────────

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on AuthException catch (e) {
      throw AuthServiceException(_mapAuthError(e));
    }
  }

  // ── FR8 — Forgot / Reset password ──────────────────────────────────────

  /// Sends a password-reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AuthServiceException(_mapAuthError(e));
    }
  }

  /// Updates the authenticated user's password (after deep-link return).
  Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (e) {
      throw AuthServiceException(_mapAuthError(e));
    }
  }

  // ── FR5 — Re-send confirmation email ───────────────────────────────────

  Future<void> resendConfirmationEmail(String email) async {
    try {
      await _auth.resend(type: OtpType.signup, email: email);
    } on AuthException catch (e) {
      throw AuthServiceException(_mapAuthError(e));
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  String _mapAuthError(AuthException e) {
    final msg = e.message.toLowerCase();
    if (msg.contains('invalid login credentials') ||
        msg.contains('invalid_credentials')) {
      return 'Incorrect email or password.';
    }
    if (msg.contains('user already registered') ||
        msg.contains('already_exists')) {
      return 'An account with this email already exists.';
    }
    if (msg.contains('email not confirmed')) {
      return 'Please confirm your email before signing in.';
    }
    if (msg.contains('weak_password') || msg.contains('weak password')) {
      return 'Password is too weak. Use at least 8 characters.';
    }
    if (msg.contains('rate_limit') || msg.contains('too many requests')) {
      return 'Too many attempts. Please wait a moment.';
    }
    return e.message;
  }
}

/// Domain-specific exception thrown by [AuthService].
class AuthServiceException implements Exception {
  final String message;
  const AuthServiceException(this.message);

  @override
  String toString() => message;
}

// ── Riverpod providers ─────────────────────────────────────────────────────

final authServiceProvider = Provider<AuthService>((_) => AuthService.instance);

/// Exposes the Supabase auth state as an async stream.
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authServiceProvider).onAuthStateChange;
});
