import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/router.dart';
import '../../../services/auth_service.dart';
import '../widgets/auth_widgets.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailCtrl.dispose();
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: _emailSent
                ? _buildSuccessView(context, l)
                : Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                              l.get('forgotPassword'),
                              style: Theme.of(context).textTheme.displayLarge,
                            )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.15),
                        const SizedBox(height: 8),
                        Text(
                          l.get('resetInstructions'),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ).animate().fadeIn(duration: 400.ms, delay: 80.ms),
                        const SizedBox(height: 32),
                        if (_errorMessage != null) ...[
                          AuthErrorBanner(message: _errorMessage!),
                          const SizedBox(height: 16),
                        ],
                        GlassCard(
                              child: TextFormField(
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _submit(),
                                decoration: InputDecoration(
                                  labelText: l.get('email'),
                                  prefixIcon: const Icon(Icons.email_outlined),
                                ),
                                validator: (v) =>
                                    (v == null || !v.contains('@'))
                                    ? l.get('invalidEmail')
                                    : null,
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 150.ms)
                            .slideY(begin: 0.1),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.info.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.info.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 18,
                                color: AppColors.info,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  l.get('verificationHint'),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: AppColors.info),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        GradientButton(
                          label: l.get('continue_'),
                          isLoading: _isLoading,
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

  Widget _buildSuccessView(BuildContext context, AppLocalizations l) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.success, Color(0xFF059669)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 44,
                color: Colors.white,
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms)
            .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
        const SizedBox(height: 24),
        Text(
          l.get('verifyEmail'),
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
        const SizedBox(height: 12),
        Text(
          l.get('verifyMessage'),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
        const SizedBox(height: 32),
        TextButton(
          onPressed: () => context.go(AppRoutes.login),
          child: Text(l.get('backToSignIn')),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      String? redirectTo;
      if (kIsWeb) {
        final uri = Uri.base;
        redirectTo = '${uri.scheme}://${uri.host}:${uri.port}';
      }
      await ref
          .read(authServiceProvider)
          .sendPasswordResetEmail(
            _emailCtrl.text.trim(),
            redirectTo: redirectTo,
          );
      if (mounted) setState(() => _emailSent = true);
    } on AuthServiceException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
