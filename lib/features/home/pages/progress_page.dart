import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/gamification.dart';
import '../../../services/profile_service.dart';
import '../providers/home_providers.dart';

class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final statsAsync = ref.watch(overallStatsProvider);
    final achievementsAsync = ref.watch(userAchievementsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Progress',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Track your medication adherence journey',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // ── Level + Streaks + Points ──
              profileAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => const SizedBox.shrink(),
                data: (profile) {
                  if (profile == null) return const SizedBox.shrink();
                  final lvl = GamificationConfig.getLevelForPoints(
                    profile.totalPoints,
                  );
                  final next = GamificationConfig.getNextLevel(
                    profile.totalPoints,
                  );
                  final progress = GamificationConfig.getLevelProgress(
                    profile.totalPoints,
                  );
                  final toGo = GamificationConfig.pointsToNextLevel(
                    profile.totalPoints,
                  );

                  return Column(
                    children: [
                      _LevelCard(
                        level: lvl.level,
                        levelName: lvl.name,
                        totalPoints: profile.totalPoints,
                        progress: progress,
                        nextLevelPoints: next?.pointsRequired,
                        pointsToGo: toGo,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _GradientStatCard(
                              icon: Icons.local_fire_department,
                              label: 'Current Streak',
                              value: '${profile.currentStreak}',
                              unit: 'days',
                              gradient: const [
                                Color(0xFFEC4899),
                                Color(0xFFF97316),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _GradientStatCard(
                              icon: Icons.emoji_events,
                              label: 'Max Streak',
                              value: '${profile.longestStreak}',
                              unit: 'days',
                              gradient: const [
                                Color(0xFF6366F1),
                                Color(0xFF3B82F6),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _GradientStatCard(
                        icon: Icons.star,
                        label: 'Total Points Earned',
                        value: '${profile.totalPoints}',
                        gradient: const [Color(0xFF14B8A6), Color(0xFF22C55E)],
                        isWide: true,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),

              // ── Achievements ──
              Text(
                'Recent Achievements',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 12),
              achievementsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => const SizedBox.shrink(),
                data: (achievements) {
                  if (achievements.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.emoji_events_outlined,
                                size: 40,
                                color: AppColors.textDisabled,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Take your first dose to earn achievements!',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          for (
                            int achievementIndex = 0;
                            achievementIndex < achievements.length;
                            achievementIndex++
                          ) ...[
                            if (achievementIndex > 0) const Divider(height: 20),
                            _AchievementTile(
                              achievement: achievements[achievementIndex],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),

              // ── Statistics ──
              Text(
                'Statistics',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 12),
              statsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => const SizedBox.shrink(),
                data: (stats) => Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        value: '${stats['taken']}',
                        label: 'Medications\nTaken',
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatBox(
                        value: '${(stats['adherenceRate'] as double).round()}%',
                        label: 'Adherence\nRate',
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatBox(
                        value: '${stats['perfectDays']}',
                        label: 'Perfect\nDays',
                        color: const Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Level Card ──────────────────────────────────────────────────────────────

class _LevelCard extends StatelessWidget {
  final int level;
  final String levelName;
  final int totalPoints;
  final double progress;
  final int? nextLevelPoints;
  final int pointsToGo;

  const _LevelCard({
    required this.level,
    required this.levelName,
    required this.totalPoints,
    required this.progress,
    this.nextLevelPoints,
    required this.pointsToGo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.rocket_launch,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Level',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Level $level',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(color: AppColors.primary),
                      ),
                      Text(
                        levelName,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$totalPoints',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(color: AppColors.primary),
                    ),
                    Text(
                      'Points',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (nextLevelPoints != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Next Level: $nextLevelPoints',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '$pointsToGo points to go',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            else
              Text(
                'Maximum level reached!',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.success),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Gradient Stat Card ──────────────────────────────────────────────────────

class _GradientStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? unit;
  final List<Color> gradient;
  final bool isWide;

  const _GradientStatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.unit,
    required this.gradient,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWide ? double.infinity : null,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: isWide ? _wideLayout(context) : _compactLayout(context),
    );
  }

  Widget _compactLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            if (unit != null) ...[
              const SizedBox(width: 4),
              Text(
                unit!,
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _wideLayout(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// ── Achievement Tile ────────────────────────────────────────────────────────

class _AchievementTile extends StatelessWidget {
  final UserAchievement achievement;

  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_icon, color: _color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                achievement.type.displayName,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 2),
              Text(
                achievement.type.description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData get _icon => switch (achievement.type) {
    AchievementType.firstDose => Icons.medication,
    AchievementType.perfectWeek => Icons.star,
    AchievementType.earlyBird => Icons.wb_sunny,
    AchievementType.consistencyChampion => Icons.emoji_events,
    AchievementType.weekWarrior => Icons.local_fire_department,
    AchievementType.monthMaster => Icons.workspace_premium,
    AchievementType.centurion => Icons.looks_one,
    AchievementType.halfMillennium => Icons.star_outline,
    AchievementType.pointsMaster => Icons.auto_awesome,
  };

  Color get _color => switch (achievement.type) {
    AchievementType.firstDose => Colors.blue,
    AchievementType.perfectWeek => Colors.amber,
    AchievementType.earlyBird => Colors.orange,
    AchievementType.consistencyChampion => Colors.purple,
    AchievementType.weekWarrior => Colors.red,
    AchievementType.monthMaster => Colors.teal,
    AchievementType.centurion => Colors.green,
    AchievementType.halfMillennium => Colors.amber,
    AchievementType.pointsMaster => Colors.indigo,
  };
}

// ── Stat Box ────────────────────────────────────────────────────────────────

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatBox({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
