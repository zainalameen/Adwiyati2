import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/router.dart';
import '../../../services/auth_service.dart';

class VerifyPage extends ConsumerStatefulWidget {
  const VerifyPage({super.key});

  @override
  ConsumerState<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends ConsumerState<VerifyPage> {
  bool _resending = false;
  bool _resent = false;

  String? get _email {
    final extra = GoRouterState.of(context).extra;
    return extra is String ? extra : null;
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mark_email_unread_outlined,
                      size: 44, color: AppColors.primary),
                ),
                const SizedBox(height: 28),
                Text(
                  l.get('verifyEmail'),
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  l.get('verifyMessage'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                if (_email != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _email!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 40),

                if (_resent)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Email resent!',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.success),
                    ),
                  ),

                Text(
                  l.get('checkSpam'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        (_resending || _email == null) ? null : _resend,
                    child: _resending
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(l.get('resendEmail')),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: Text(l.get('backToSignIn')),
                ),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resend() async {
    if (_email == null) return;
    setState(() => _resending = true);
    try {
      await ref
          .read(authServiceProvider)
          .resendConfirmationEmail(_email!);
      if (mounted) setState(() => _resent = true);
    } on AuthServiceException catch (_) {
      // silent — avoid leaking info
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }
}
