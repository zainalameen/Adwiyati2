import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/active_treatment_model.dart';
import '../../../core/models/dose_reminder_model.dart';
import '../../../services/supabase_service.dart';
import '../../../services/treatment_service.dart';
import '../models/treatment_with_medication.dart';

final treatmentsListProvider = FutureProvider.family<
    List<TreatmentWithMedication>, TreatmentStatus>((ref, status) async {
  final user = SupabaseService.auth.currentUser;
  if (user == null) return [];
  return TreatmentService.instance.listTreatmentsForUser(user.id, status);
});

final treatmentDetailProvider = FutureProvider.family<
    TreatmentWithMedication?, String>((ref, treatmentId) async {
  final user = SupabaseService.auth.currentUser;
  if (user == null) return null;
  return TreatmentService.instance.getTreatmentWithMedication(
    treatmentId,
    user.id,
  );
});

final treatmentRemindersProvider =
    FutureProvider.family<List<DoseReminderModel>, String>((ref, treatmentId) async {
  return TreatmentService.instance.listReminderSchedules(treatmentId);
});
