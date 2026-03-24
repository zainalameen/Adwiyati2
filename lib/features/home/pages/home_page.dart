import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/models/dose_reminder_model.dart';
import '../../../services/gamification_service.dart';
import '../../../services/home_service.dart';
import '../../../services/profile_service.dart';
import '../../../services/supabase_service.dart';
import '../models/dose_with_medication.dart';
import '../providers/home_providers.dart';
import '../widgets/calendar_strip.dart';
import '../widgets/dose_tile.dart';
import '../widgets/progress_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _streakValidated = false;

  @override
  void initState() {
    super.initState();
    _validateStreak();
  }

  Future<void> _validateStreak() async {
    if (_streakValidated) return;
    _streakValidated = true;
    final user = SupabaseService.auth.currentUser;
    if (user != null) {
      await GamificationService.instance.validateStreak(user.id);
    }
  }

  Future<void> _onDoseTaken(DoseWithMedication dose) async {
    final user = SupabaseService.auth.currentUser;
    if (user == null) return;

    try {
      await HomeService.instance.markDoseTaken(dose.reminderId);
      await GamificationService.instance.onDoseTaken(user.id);
      ref.invalidate(dosesForDateProvider);
      ref.invalidate(userProfileProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark dose: $e')),
        );
      }
    }
  }

  Future<void> _onDoseSkipped(DoseWithMedication dose) async {
    try {
      await HomeService.instance.markDoseSkipped(dose.reminderId);
      ref.invalidate(dosesForDateProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to skip dose: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final dosesAsync = ref.watch(dosesForDateProvider);
    final progress = ref.watch(todayProgressProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
        ),
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dosesForDateProvider);
              ref.invalidate(userProfileProvider);
            },
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 24),
                      CalendarStrip(
                        selectedDate: selectedDate,
                        onDateSelected: (date) {
                          ref.read(selectedDateProvider.notifier).select(date);
                        },
                      ),
                      const SizedBox(height: 32),
                      _buildToTakeSection(context, dosesAsync),
                      const SizedBox(height: 32),
                      ProgressCard(
                        adherencePercent: progress['adherence'] as int,
                        taken: progress['taken'] as int,
                        scheduled: progress['total'] as int,
                        streak: profileAsync.when(
                          data: (p) => p?.currentStreak ?? 0,
                          loading: () => 0,
                          error: (_, __) => 0,
                        ),
                        onTap: () => context.push('/progress'),
                      ),
                      const SizedBox(height: 100), // Padding for floating nav bar
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToTakeSection(
    BuildContext context,
    AsyncValue<List<DoseWithMedication>> dosesAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.medication,
                  size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Text('To Take', style: Theme.of(context).textTheme.displaySmall),
          ],
        ),
        const SizedBox(height: 20),
        dosesAsync.when(
          skipLoadingOnRefresh: true,
          loading: () => const _DoseLoadingPlaceholder(),
          error: (e, _) => Center(
            child: Text(
              'Could not load doses',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.error),
            ),
          ),
          data: (doses) {
            if (doses.isEmpty) return _buildEmptyDoses(context);
            return _buildDoseList(context, doses);
          },
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, curve: Curves.easeOut);
  }

  Widget _buildEmptyDoses(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Lottie.network(
            'https://assets9.lottiefiles.com/packages/lf20_q0vtqaxf.json', // Medical related lottie
            width: 180,
            height: 180,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You\'re all caught up!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'No more doses scheduled for today.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDoseList(BuildContext context, List<DoseWithMedication> doses) {
    final grouped = <String, List<DoseWithMedication>>{};
    for (final dose in doses) {
      grouped.putIfAbsent(dose.timeCategory, () => []).add(dose);
    }

    const order = ['After Breakfast', 'After Lunch', 'After Dinner', 'Before Bed'];
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => order.indexOf(a).compareTo(order.indexOf(b)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < sortedKeys.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          _buildTimeGroup(context, sortedKeys[i], grouped[sortedKeys[i]]!, i),
        ],
      ],
    );
  }

  Widget _buildTimeGroup(
    BuildContext context,
    String category,
    List<DoseWithMedication> doses,
    int index,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
          child: Text(
            category,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
          ),
        ),
        ...doses.map(
          (dose) => DoseTile(
            dose: dose,
            onTaken: dose.status == DoseReminderStatus.pending
                ? () => _onDoseTaken(dose)
                : null,
            onSkipped: dose.status == DoseReminderStatus.pending
                ? () => _onDoseSkipped(dose)
                : null,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: Duration(milliseconds: 150 + (index * 100))).slideY(begin: 0.1);
  }
}

class _DoseLoadingPlaceholder extends StatelessWidget {
  const _DoseLoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              'Loading doses...',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
