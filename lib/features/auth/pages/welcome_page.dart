import 'package:flutter/material.dart';
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
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Language toggle — top right
                Align(
                  alignment:
                      isAr ? Alignment.centerLeft : Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ref.read(localeProvider.notifier).toggle();
                    },
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

                // Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.medication_rounded,
                      color: Colors.white, size: 52),
                ),
                const SizedBox(height: 28),

                // Title
                Text(
                  l.get('appName'),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.primary,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.get('appTagline'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(flex: 3),

                // Buttons
                ElevatedButton(
                  onPressed: () => context.push(AppRoutes.login),
                  child: Text(l.get('signIn')),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.push(AppRoutes.signup),
                  child: Text(l.get('signUp')),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
