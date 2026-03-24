import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/router.dart';
import '../../../services/auth_service.dart';
import '../widgets/auth_widgets.dart';

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
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.mark_email_unread_outlined,
                        size: 44, color: Colors.white),
                  ).animate().fadeIn(duration: 500.ms).scale(
                      begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
                  const SizedBox(height: 28),
                  Text(
                    l.get('verifyEmail'),
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
                  const SizedBox(height: 12),
                  Text(
                    l.get('verifyMessage'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.success.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_outline,
                                color: AppColors.success, size: 18),
                            const SizedBox(width: 8),
                            Text('Email resent!',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.success)),
                          ],
                        ),
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
                    child: GradientButton(
                      label: l.get('resendEmail'),
                      isLoading: _resending,
                      onTap: (_email == null) ? null : _resend,
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
      await ref.read(authServiceProvider).resendConfirmationEmail(_email!);
      if (mounted) setState(() => _resent = true);
    } on AuthServiceException catch (_) {
      // silent
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }
}
