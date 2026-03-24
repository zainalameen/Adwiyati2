import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/router.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final l = AppLocalizations(locale);
    final isAr = l.isArabic;

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: AppColors.background),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Align(
                    alignment:
                        isAr ? Alignment.centerLeft : Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => ref.read(localeProvider.notifier).toggle(),
                      child: Text(
                        l.get('language'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.medication_rounded,
                        color: Colors.white, size: 56),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
                  const SizedBox(height: 28),
                  Text(
                    l.get('appName'),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      foreground: Paint()
                        ..shader = AppColors.primaryGradient.createShader(
                            const Rect.fromLTWH(0, 0, 200, 50)),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 200.ms)
                      .slideY(begin: 0.2),
                  const SizedBox(height: 8),
                  Text(
                    l.get('appTagline'),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
                  const Spacer(flex: 3),
                  _GradientButton(
                    label: l.get('signIn'),
                    onTap: () => context.push(AppRoutes.login),
                  ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideY(begin: 0.2),
                  const SizedBox(height: 12),
                  _GlassOutlineButton(
                    label: l.get('signUp'),
                    onTap: () => context.push(AppRoutes.signup),
                  ).animate().fadeIn(duration: 400.ms, delay: 500.ms).slideY(begin: 0.2),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _GradientButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _GlassOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _GlassOutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            alignment: Alignment.center,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}
