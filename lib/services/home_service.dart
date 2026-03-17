import '../core/models/dose_reminder_model.dart';
import '../features/home/models/dose_with_medication.dart';
import 'supabase_service.dart';

class HomeService {
  HomeService._();
  static final instance = HomeService._();

  Future<List<DoseWithMedication>> getDosesForDate(
    String userId,
    DateTime date,
  ) async {
    final dateStr = _fmtDate(date);

    final treatments = await SupabaseService.db
        .from(SupabaseService.activeTreatmentTable)
        .select('treatment_id, medication_id')
        .eq('user_id', userId)
        .eq('status', 'active');

    if ((treatments as List).isEmpty) return [];

    final treatmentIds =
        treatments.map((t) => t['treatment_id'] as String).toList();
    final medicationIds =
        treatments.map((t) => t['medication_id'] as String).toSet().toList();

    final results = await Future.wait([
      SupabaseService.db
          .from(SupabaseService.doseReminderTable)
          .select()
          .inFilter('treatment_id', treatmentIds)
          .eq('planned_date', dateStr)
          .order('planned_time'),
      SupabaseService.db
          .from(SupabaseService.medicationTable)
          .select(
            'medication_id, trade_name_en, trade_name_ar, dosage_form, dose_amount, unit, dose_instructions',
          )
          .inFilter('medication_id', medicationIds),
    ]);

    final doses = results[0] as List;
    final medications = results[1] as List;

    final medMap = {
      for (var m in medications) m['medication_id'] as String: m,
    };
    final treatmentMedMap = {
      for (var t in treatments)
        t['treatment_id'] as String: medMap[t['medication_id'] as String],
    };

    return doses.map((d) {
      final med = treatmentMedMap[d['treatment_id'] as String];
      return DoseWithMedication(
        reminderId: d['reminder_id'] as String,
        treatmentId: d['treatment_id'] as String,
        plannedDate: DateTime.parse(d['planned_date'] as String),
        plannedTime: d['planned_time'] as String,
        actualTime: d['actual_time'] as String?,
        quantityToTake: (d['quantity_to_take'] as num).toDouble(),
        status: DoseReminderStatusX.fromString(d['status'] as String),
        medicationName: med?['trade_name_en'] as String? ?? 'Unknown',
        medicationNameAr: med?['trade_name_ar'] as String? ?? '',
        dosageForm: med?['dosage_form'] as String? ?? 'tablet',
        doseAmount: (med?['dose_amount'] as num?)?.toDouble() ?? 0,
        unit: med?['unit'] as String?,
        doseInstructions: med?['dose_instructions'] as String?,
      );
    }).toList();
  }

  Future<void> markDoseTaken(String reminderId) async {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00';
    await SupabaseService.db
        .from(SupabaseService.doseReminderTable)
        .update({'status': 'taken', 'actual_time': timeStr})
        .eq('reminder_id', reminderId);
  }

  Future<void> markDoseSkipped(String reminderId) async {
    await SupabaseService.db
        .from(SupabaseService.doseReminderTable)
        .update({'status': 'skipped'})
        .eq('reminder_id', reminderId);
  }

  Future<Map<String, dynamic>> getOverallStats(String userId) async {
    final treatments = await SupabaseService.db
        .from(SupabaseService.activeTreatmentTable)
        .select('treatment_id')
        .eq('user_id', userId);

    if ((treatments as List).isEmpty) {
      return {
        'taken': 0,
        'total': 0,
        'perfectDays': 0,
        'adherenceRate': 0.0,
      };
    }

    final treatmentIds =
        treatments.map((t) => t['treatment_id'] as String).toList();

    final allDoses = await SupabaseService.db
        .from(SupabaseService.doseReminderTable)
        .select('planned_date, status')
        .inFilter('treatment_id', treatmentIds);

    final totalDoses = (allDoses as List).length;
    final takenDoses = allDoses.where((d) => d['status'] == 'taken').length;

    final byDate = <String, List<String>>{};
    for (final d in allDoses) {
      final date = d['planned_date'] as String;
      byDate.putIfAbsent(date, () => []).add(d['status'] as String);
    }
    final perfectDays = byDate.values
        .where((statuses) => statuses.every((s) => s == 'taken'))
        .length;

    return {
      'taken': takenDoses,
      'total': totalDoses,
      'perfectDays': perfectDays,
      'adherenceRate':
          totalDoses > 0 ? (takenDoses / totalDoses * 100) : 0.0,
    };
  }

  static String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
