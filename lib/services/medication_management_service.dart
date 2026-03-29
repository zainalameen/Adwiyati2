import 'package:flutter/material.dart';

import 'supabase_service.dart';

class MedicationOption {
  final String id;
  final String tradeNameEn;
  final String dosageForm;
  final double doseAmount;
  final String? unit;

  const MedicationOption({
    required this.id,
    required this.tradeNameEn,
    required this.dosageForm,
    required this.doseAmount,
    this.unit,
  });
}

class ReminderInput {
  final TimeOfDay time;
  final String frequency;
  final double quantityPerDose;

  const ReminderInput({
    required this.time,
    required this.frequency,
    required this.quantityPerDose,
  });
}

class MedicationManagementService {
  MedicationManagementService._();
  static final instance = MedicationManagementService._();

  Future<List<MedicationOption>> fetchMedicationOptions() async {
    final rows = await SupabaseService.db
        .from(SupabaseService.medicationTable)
        .select('medication_id, trade_name_en, dosage_form, dose_amount, unit')
        .order('trade_name_en', ascending: true);

    final meds = (rows as List)
        .map(
          (row) => MedicationOption(
            id: row['medication_id'] as String,
            tradeNameEn:
                row['trade_name_en'] as String? ?? 'Unknown medication',
            dosageForm: row['dosage_form'] as String? ?? 'Pill',
            doseAmount: (row['dose_amount'] as num?)?.toDouble() ?? 0,
            unit: row['unit'] as String?,
          ),
        )
        .toList();

    meds.sort(
      (a, b) =>
          a.tradeNameEn.toLowerCase().compareTo(b.tradeNameEn.toLowerCase()),
    );
    return meds;
  }

  Future<bool> hasPotentialInteraction({
    required String userId,
    required String medicationId,
  }) async {
    final active = await SupabaseService.db
        .from(SupabaseService.activeTreatmentTable)
        .select('medication_id')
        .eq('user_id', userId)
        .eq('status', 'active')
        .eq('medication_id', medicationId);
    return (active as List).isNotEmpty;
  }

  Future<void> createCabinetMedication({
    required String userId,
    required String medicationId,
    required double quantity,
    required DateTime expiryDate,
  }) async {
    await SupabaseService.db.from(SupabaseService.cabinetMedTable).insert({
      'user_id': userId,
      'medication_id': medicationId,
      'quantity': quantity,
      'expiration_date': _fmtDate(expiryDate),
    });
  }

  Future<void> createActiveTreatment({
    required String userId,
    required String medicationId,
    required double currentQuantity,
    required DateTime expiryDate,
    required DateTime? endDate,
    required int? pillsToTake,
    required List<ReminderInput> reminders,
  }) async {
    final treatmentRows = await SupabaseService.db
        .from(SupabaseService.activeTreatmentTable)
        .insert({
          'user_id': userId,
          'medication_id': medicationId,
          'start_date': DateTime.now().toIso8601String(),
          'end_date': endDate?.toIso8601String(),
          'times_per_day': reminders.length,
          'interval_days': 1,
          'current_quantity': currentQuantity,
          'pills_to_take': pillsToTake,
          'expiry_date': _fmtDate(expiryDate),
          'status': 'active',
        })
        .select('treatment_id');

    final treatmentId = (treatmentRows as List).first['treatment_id'] as String;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Seed one day of reminders; next scheduling can be automated later.
    final reminderRows = reminders
        .map(
          (r) => {
            'treatment_id': treatmentId,
            'planned_date': _fmtDate(todayDate),
            'planned_time': _fmtTime(r.time),
            'quantity_to_take': r.quantityPerDose,
            'status': 'pending',
          },
        )
        .toList();

    await SupabaseService.db
        .from(SupabaseService.doseReminderTable)
        .insert(reminderRows);
  }

  static String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';
}
