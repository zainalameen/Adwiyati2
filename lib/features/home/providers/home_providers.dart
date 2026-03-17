import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/gamification.dart';
import '../../../core/models/dose_reminder_model.dart';
import '../../../services/gamification_service.dart';
import '../../../services/home_service.dart';
import '../../../services/supabase_service.dart';
import '../models/dose_with_medication.dart';

class _SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void select(DateTime date) => state = date;
}

final selectedDateProvider =
    NotifierProvider<_SelectedDateNotifier, DateTime>(
        _SelectedDateNotifier.new);

final dosesForDateProvider =
    FutureProvider.autoDispose<List<DoseWithMedication>>((ref) async {
  final user = SupabaseService.auth.currentUser;
  if (user == null) return [];
  final date = ref.watch(selectedDateProvider);
  return HomeService.instance.getDosesForDate(user.id, date);
});

final todayProgressProvider =
    Provider.autoDispose<Map<String, dynamic>>((ref) {
  final dosesAsync = ref.watch(dosesForDateProvider);
  return dosesAsync.when(
    data: (doses) {
      final total = doses.length;
      final taken =
          doses.where((d) => d.status == DoseReminderStatus.taken).length;
      final adherence = total > 0 ? (taken / total * 100).round() : 0;
      return {'taken': taken, 'total': total, 'adherence': adherence};
    },
    loading: () => {'taken': 0, 'total': 0, 'adherence': 0},
    error: (_, __) => {'taken': 0, 'total': 0, 'adherence': 0},
  );
});

final overallStatsProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final user = SupabaseService.auth.currentUser;
  if (user == null) {
    return {'taken': 0, 'total': 0, 'perfectDays': 0, 'adherenceRate': 0.0};
  }
  return HomeService.instance.getOverallStats(user.id);
});

final userAchievementsProvider =
    FutureProvider.autoDispose<List<UserAchievement>>((ref) async {
  final user = SupabaseService.auth.currentUser;
  if (user == null) return [];
  return GamificationService.instance.getUserAchievements(user.id);
});
