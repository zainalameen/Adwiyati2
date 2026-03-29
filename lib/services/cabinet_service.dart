import 'package:uuid/uuid.dart';

import '../core/models/cabinet_med_model.dart';
import '../core/models/medication_model.dart';
import '../features/cabinet/models/cabinet_entry.dart';
import 'supabase_service.dart';

class CabinetService {
  CabinetService._();
  static final instance = CabinetService._();

  Future<List<CabinetEntry>> listCabinetForUser(String userId) async {
    final rows = await SupabaseService.db
        .from(SupabaseService.cabinetMedTable)
        .select()
        .eq('user_id', userId)
        .order('expiration_date');

    final list = rows as List<dynamic>;
    if (list.isEmpty) return [];

    final cabinets = list
        .map((e) => CabinetMedModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final medIds = cabinets.map((c) => c.medicationId).toSet().toList();

    final medRows = await SupabaseService.db
        .from(SupabaseService.medicationTable)
        .select()
        .inFilter('medication_id', medIds);

    final medMap = {
      for (final m in medRows as List)
        m['medication_id'] as String: MedicationModel.fromJson(
          m as Map<String, dynamic>,
        ),
    };

    return cabinets
        .map(
          (c) => CabinetEntry(cabinet: c, medication: medMap[c.medicationId]!),
        )
        .toList();
  }

  Future<CabinetEntry?> getCabinetEntry(
    String cabinetMedId,
    String userId,
  ) async {
    final row = await SupabaseService.db
        .from(SupabaseService.cabinetMedTable)
        .select()
        .eq('cabinet_med_id', cabinetMedId)
        .eq('user_id', userId)
        .maybeSingle();

    if (row == null) return null;

    final cabinet = CabinetMedModel.fromJson(Map<String, dynamic>.from(row));

    final medRow = await SupabaseService.db
        .from(SupabaseService.medicationTable)
        .select()
        .eq('medication_id', cabinet.medicationId)
        .maybeSingle();

    if (medRow == null) return null;

    return CabinetEntry(
      cabinet: cabinet,
      medication: MedicationModel.fromJson(Map<String, dynamic>.from(medRow)),
    );
  }

  Future<void> updateCabinetAndMedication({
    required String cabinetMedId,
    required String userId,
    required String medicationId,
    required String tradeNameEn,
    required String dosageForm,
    required double doseAmount,
    String? unit,
    required double quantity,
    required DateTime expirationDate,
  }) async {
    await SupabaseService.db
        .from(SupabaseService.cabinetMedTable)
        .update({
          'quantity': quantity,
          'expiration_date': expirationDate.toIso8601String().split('T').first,
        })
        .eq('cabinet_med_id', cabinetMedId)
        .eq('user_id', userId);

    await SupabaseService.db
        .from(SupabaseService.medicationTable)
        .update({
          'trade_name_en': tradeNameEn,
          'dosage_form': dosageForm,
          'dose_amount': doseAmount,
          'unit': unit,
        })
        .eq('medication_id', medicationId);
  }

  Future<void> deleteCabinetEntry(String cabinetMedId, String userId) async {
    await SupabaseService.db
        .from(SupabaseService.cabinetMedTable)
        .delete()
        .eq('cabinet_med_id', cabinetMedId)
        .eq('user_id', userId);
  }

  /// Creates an [active_treatment] row using cabinet stock. Returns new treatment id.
  Future<String> addToActiveTreatments({
    required String userId,
    required String medicationId,
    required double currentQuantity,
    required DateTime expiryDate,
  }) async {
    final existing = await SupabaseService.db
        .from(SupabaseService.activeTreatmentTable)
        .select('treatment_id')
        .eq('user_id', userId)
        .eq('medication_id', medicationId)
        .eq('status', 'active')
        .maybeSingle();

    if (existing != null) {
      throw CabinetException(
        'This medication is already in your active treatments.',
      );
    }

    final treatmentId = const Uuid().v4();
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    await SupabaseService.db.from(SupabaseService.activeTreatmentTable).insert({
      'treatment_id': treatmentId,
      'user_id': userId,
      'medication_id': medicationId,
      'start_date': todayStr,
      'end_date': null,
      'times_per_day': 1,
      'interval_days': 1,
      'current_quantity': currentQuantity,
      'pills_taken_so_far': 0,
      'pills_to_take': null,
      'expiry_date': expiryDate.toIso8601String().split('T').first,
      'status': 'active',
    });

    return treatmentId;
  }
}

class CabinetException implements Exception {
  final String message;
  CabinetException(this.message);

  @override
  String toString() => message;
}
