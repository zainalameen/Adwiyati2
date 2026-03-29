import '../core/constants/gamification.dart';
import 'supabase_service.dart';

class GamificationService {
  GamificationService._();
  static final instance = GamificationService._();

  /// Call after a dose is marked as taken.
  Future<void> onDoseTaken(String userId) async {
    int pointsEarned = GamificationConfig.pointsPerDose;

    final treatments = await SupabaseService.db
        .from(SupabaseService.activeTreatmentTable)
        .select('treatment_id')
        .eq('user_id', userId)
        .eq('status', 'active');

    if ((treatments as List).isNotEmpty) {
      final tIds = treatments.map((t) => t['treatment_id'] as String).toList();
      final todayStr = _fmtDate(DateTime.now());

      final todayDoses = await SupabaseService.db
          .from(SupabaseService.doseReminderTable)
          .select('status')
          .inFilter('treatment_id', tIds)
          .eq('planned_date', todayStr);

      final allTaken =
          (todayDoses as List).isNotEmpty &&
          todayDoses.every((d) => d['status'] == 'taken');

      if (allTaken) {
        pointsEarned += GamificationConfig.perfectDayBonus;
        await _updateStreak(userId, DateTime.now());
      }
    }

    await _addPoints(userId, pointsEarned);
    await _checkAchievements(userId);
  }

  Future<void> _updateStreak(String userId, DateTime today) async {
    final profile = await SupabaseService.db
        .from(SupabaseService.userProfileTable)
        .select('current_streak, longest_streak, last_action_date')
        .eq('user_id', userId)
        .single();

    int currentStreak = (profile['current_streak'] as num?)?.toInt() ?? 0;
    int longestStreak = (profile['longest_streak'] as num?)?.toInt() ?? 0;
    final lastAction = profile['last_action_date'] != null
        ? DateTime.parse(profile['last_action_date'] as String)
        : null;

    final todayDate = DateTime(today.year, today.month, today.day);
    final lastDate = lastAction != null
        ? DateTime(lastAction.year, lastAction.month, lastAction.day)
        : null;

    if (lastDate != null && todayDate.difference(lastDate).inDays == 0) {
      return;
    } else if (lastDate != null && todayDate.difference(lastDate).inDays == 1) {
      currentStreak += 1;
    } else {
      currentStreak = 1;
    }

    if (currentStreak > longestStreak) longestStreak = currentStreak;

    await SupabaseService.db
        .from(SupabaseService.userProfileTable)
        .update({
          'current_streak': currentStreak,
          'longest_streak': longestStreak,
          'last_action_date': todayDate.toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', userId);
  }

  Future<void> _addPoints(String userId, int points) async {
    final profile = await SupabaseService.db
        .from(SupabaseService.userProfileTable)
        .select('total_points')
        .eq('user_id', userId)
        .single();

    final newTotal = ((profile['total_points'] as num?)?.toInt() ?? 0) + points;
    final newLevel = GamificationConfig.getLevelForPoints(newTotal).level;

    await SupabaseService.db
        .from(SupabaseService.userProfileTable)
        .update({
          'total_points': newTotal,
          'level': newLevel,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', userId);
  }

  /// Resets streak if last perfect day was more than 1 day ago.
  Future<void> validateStreak(String userId) async {
    final profile = await SupabaseService.db
        .from(SupabaseService.userProfileTable)
        .select('current_streak, last_action_date')
        .eq('user_id', userId)
        .single();

    final currentStreak = (profile['current_streak'] as num?)?.toInt() ?? 0;
    if (currentStreak == 0) return;

    final lastAction = profile['last_action_date'] != null
        ? DateTime.parse(profile['last_action_date'] as String)
        : null;
    if (lastAction == null) return;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final lastDate = DateTime(
      lastAction.year,
      lastAction.month,
      lastAction.day,
    );

    if (todayDate.difference(lastDate).inDays > 1) {
      await SupabaseService.db
          .from(SupabaseService.userProfileTable)
          .update({
            'current_streak': 0,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId);
    }
  }

  Future<List<UserAchievement>> getUserAchievements(String userId) async {
    final res = await SupabaseService.db
        .from(SupabaseService.userAchievementTable)
        .select()
        .eq('user_id', userId)
        .order('achieved_at', ascending: false);

    return (res as List).map((e) => UserAchievement.fromJson(e)).toList();
  }

  Future<void> _checkAchievements(String userId) async {
    final profile = await SupabaseService.db
        .from(SupabaseService.userProfileTable)
        .select('total_points, current_streak, longest_streak')
        .eq('user_id', userId)
        .single();

    final existing = await SupabaseService.db
        .from(SupabaseService.userAchievementTable)
        .select('achievement_type')
        .eq('user_id', userId);

    final earned = existing.map((e) => e['achievement_type'] as String).toSet();
    final totalPoints = (profile['total_points'] as num?)?.toInt() ?? 0;
    final longestStreak = (profile['longest_streak'] as num?)?.toInt() ?? 0;

    final toAward = <String>[];

    void check(AchievementType type, bool condition) {
      if (!earned.contains(type.name) && condition) toAward.add(type.name);
    }

    check(AchievementType.firstDose, true);
    check(AchievementType.weekWarrior, longestStreak >= 7);
    check(AchievementType.perfectWeek, longestStreak >= 7);
    check(AchievementType.monthMaster, longestStreak >= 30);
    check(AchievementType.halfMillennium, totalPoints >= 500);
    check(AchievementType.pointsMaster, totalPoints >= 1000);

    if (!earned.contains(AchievementType.centurion.name)) {
      final treatments = await SupabaseService.db
          .from(SupabaseService.activeTreatmentTable)
          .select('treatment_id')
          .eq('user_id', userId);

      if ((treatments as List).isNotEmpty) {
        final tIds = treatments
            .map((t) => t['treatment_id'] as String)
            .toList();
        final taken = await SupabaseService.db
            .from(SupabaseService.doseReminderTable)
            .select('reminder_id')
            .inFilter('treatment_id', tIds)
            .eq('status', 'taken');
        if ((taken as List).length >= 100) {
          toAward.add(AchievementType.centurion.name);
        }
      }
    }

    if (toAward.isNotEmpty) {
      final rows = toAward
          .map((type) => {'user_id': userId, 'achievement_type': type})
          .toList();
      await SupabaseService.db
          .from(SupabaseService.userAchievementTable)
          .upsert(rows);
    }
  }

  static String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
