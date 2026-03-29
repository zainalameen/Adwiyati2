class LevelInfo {
  final int level;
  final String name;
  final int pointsRequired;

  const LevelInfo({
    required this.level,
    required this.name,
    required this.pointsRequired,
  });
}

abstract final class GamificationConfig {
  static const int pointsPerDose = 10;
  static const int onTimeBonusPoints = 5;
  static const int perfectDayBonus = 20;

  static const List<LevelInfo> levels = [
    LevelInfo(level: 1, name: 'Beginner', pointsRequired: 0),
    LevelInfo(level: 2, name: 'Starter', pointsRequired: 100),
    LevelInfo(level: 3, name: 'Committed', pointsRequired: 300),
    LevelInfo(level: 4, name: 'Dedicated', pointsRequired: 600),
    LevelInfo(level: 5, name: 'Health Hero', pointsRequired: 1000),
    LevelInfo(level: 6, name: 'Wellness Warrior', pointsRequired: 1500),
    LevelInfo(level: 7, name: 'Med Master', pointsRequired: 2100),
    LevelInfo(level: 8, name: 'Health Champion', pointsRequired: 2800),
    LevelInfo(level: 9, name: 'Wellness Expert', pointsRequired: 3600),
    LevelInfo(level: 10, name: 'Legendary', pointsRequired: 4500),
  ];

  static LevelInfo getLevelForPoints(int totalPoints) {
    LevelInfo current = levels.first;
    for (final l in levels) {
      if (totalPoints >= l.pointsRequired) {
        current = l;
      } else {
        break;
      }
    }
    return current;
  }

  static LevelInfo? getNextLevel(int totalPoints) {
    for (final l in levels) {
      if (totalPoints < l.pointsRequired) return l;
    }
    return null;
  }

  static double getLevelProgress(int totalPoints) {
    final current = getLevelForPoints(totalPoints);
    final next = getNextLevel(totalPoints);
    if (next == null) return 1.0;
    final range = next.pointsRequired - current.pointsRequired;
    final progress = totalPoints - current.pointsRequired;
    return range > 0 ? progress / range : 1.0;
  }

  static int pointsToNextLevel(int totalPoints) {
    final next = getNextLevel(totalPoints);
    if (next == null) return 0;
    return next.pointsRequired - totalPoints;
  }
}

enum AchievementType {
  firstDose('First Step', 'Logged your first dose'),
  perfectWeek('Perfect Week', '7 days of perfect adherence'),
  earlyBird('Early Bird', 'Took morning meds on time 10 times'),
  consistencyChampion('Consistency Champion', '90%+ adherence for a month'),
  weekWarrior('Week Warrior', 'Achieved a 7-day streak'),
  monthMaster('Month Master', 'Achieved a 30-day streak'),
  centurion('Centurion', 'Took 100 medications total'),
  halfMillennium('500 Club', 'Earned 500 total points'),
  pointsMaster('Points Master', 'Earned 1000 total points');

  final String displayName;
  final String description;

  const AchievementType(this.displayName, this.description);

  static AchievementType? fromString(String s) {
    for (final v in values) {
      if (v.name == s) return v;
    }
    return null;
  }
}

class UserAchievement {
  final String achievementId;
  final String userId;
  final AchievementType type;
  final DateTime achievedAt;

  const UserAchievement({
    required this.achievementId,
    required this.userId,
    required this.type,
    required this.achievedAt,
  });

  factory UserAchievement.fromJson(Map<String, dynamic> json) {
    return UserAchievement(
      achievementId: json['achievement_id'] as String,
      userId: json['user_id'] as String,
      type:
          AchievementType.fromString(json['achievement_type'] as String) ??
          AchievementType.firstDose,
      achievedAt: DateTime.parse(json['achieved_at'] as String),
    );
  }
}
