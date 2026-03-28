import '../core/models/active_treatment_model.dart';
import '../core/models/dose_reminder_model.dart';
import '../core/models/medication_model.dart';
import '../features/treatments/models/treatment_with_medication.dart';
import 'supabase_service.dart';

class TreatmentService {
  TreatmentService._();
  static final instance = TreatmentService._();

  Future<List<TreatmentWithMedication>> listTreatmentsForUser(
    String userId,
    TreatmentStatus status,
  ) async {
    final rows = await SupabaseService.db
        .from(SupabaseService.activeTreatmentTable)
        .select()
        .eq('user_id', userId)
        .eq('status', status.value)
        .order('start_date', ascending: false);

    final list = rows as List<dynamic>;
    if (list.isEmpty) return [];

    final treatments = list
        .map((e) => ActiveTreatmentModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final medicationIds =
        treatments.map((t) => t.medicationId).toSet().toList();

    final medRows = await SupabaseService.db
        .from(SupabaseService.medicationTable)
        .select()
        .inFilter('medication_id', medicationIds);

    final medMap = {
      for (final m in medRows as List)
        m['medication_id'] as String:
            MedicationModel.fromJson(m as Map<String, dynamic>),
    };

    return treatments
        .map((t) => TreatmentWithMedication(
              treatment: t,
              medication: medMap[t.medicationId]!,
            ))
        .toList();
  }

  Future<TreatmentWithMedication?> getTreatmentWithMedication(
    String treatmentId,
    String userId,
  ) async {
    final row = await SupabaseService.db
        .from(SupabaseService.activeTreatmentTable)
        .select()
        .eq('treatment_id', treatmentId)
        .eq('user_id', userId)
        .maybeSingle();

    if (row == null) return null;

    final treatment =
        ActiveTreatmentModel.fromJson(Map<String, dynamic>.from(row));

    final medRow = await SupabaseService.db
        .from(SupabaseService.medicationTable)
        .select()
        .eq('medication_id', treatment.medicationId)
        .maybeSingle();

    if (medRow == null) return null;

    return TreatmentWithMedication(
      treatment: treatment,
      medication: MedicationModel.fromJson(Map<String, dynamic>.from(medRow)),
    );
  }

  /// Distinct reminder times for this treatment (any upcoming/past row).
  Future<List<DoseReminderModel>> listReminderSchedules(
    String treatmentId,
  ) async {
    final rows = await SupabaseService.db
        .from(SupabaseService.doseReminderTable)
        .select()
        .eq('treatment_id', treatmentId)
        .order('planned_time');

    if ((rows as List).isEmpty) return [];

    final byTime = <String, DoseReminderModel>{};
    for (final r in rows as List) {
      final m = DoseReminderModel.fromJson(Map<String, dynamic>.from(r));
      byTime[m.plannedTime] = m;
    }
    return byTime.values.toList()
      ..sort((a, b) => a.plannedTime.compareTo(b.plannedTime));
  }

  Future<void> updateTreatmentAndMedication({
    required String treatmentId,
    required String userId,
    required String medicationId,
    required DateTime startDate,
    DateTime? endDate,
    required int timesPerDay,
    required int intervalDays,
    required double currentQuantity,
    required DateTime expiryDate,
    required String dosageForm,
    required double doseAmount,
    String? unit,
    required String tradeNameEn,
  }) async {
    await SupabaseService.db
        .from(SupabaseService.activeTreatmentTable)
        .update({
          'start_date': startDate.toIso8601String(),
          'end_date': endDate?.toIso8601String(),
          'times_per_day': timesPerDay,
          'interval_days': intervalDays,
          'current_quantity': currentQuantity,
          'expiry_date': expiryDate.toIso8601String().split('T').first,
        })
        .eq('treatment_id', treatmentId)
        .eq('user_id', userId);

    await SupabaseService.db.from(SupabaseService.medicationTable).update({
      'dosage_form': dosageForm,
      'dose_amount': doseAmount,
      'unit': unit,
      'trade_name_en': tradeNameEn,
    }).eq('medication_id', medicationId);
  }

  Future<void> completeTreatment(String treatmentId, String userId) async {
    final today = DateTime.now();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    await SupabaseService.db
        .from(SupabaseService.activeTreatmentTable)
        .update({
          'status': TreatmentStatus.completed.value,
          'end_date': dateStr,
        })
        .eq('treatment_id', treatmentId)
        .eq('user_id', userId);
  }
}
