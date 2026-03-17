import 'package:supabase_flutter/supabase_flutter.dart';

/// Singleton accessor for the Supabase client.
///
/// Use [db] for database queries and [auth] for authentication.
final class SupabaseService {
  SupabaseService._();

  static SupabaseClient get db => Supabase.instance.client;

  static GoTrueClient get auth => Supabase.instance.client.auth;

  // ── Table names ──────────────────────────────────────────────────────────
  static const String userProfileTable = 'user_profile';
  static const String medicationTable = 'medication';
  static const String activeTreatmentTable = 'active_treatment';
  static const String doseReminderTable = 'dose_reminder';
  static const String cabinetMedTable = 'cabinet_med';
  static const String allergiesConditionsTable = 'allergies_and_conditions';
  static const String userAllergiesConditionsTable = 'user_allergies_and_conditions';
  static const String useCategoryTable = 'use_category';
  static const String medicationUsesTable = 'medication_uses';
  static const String treatmentUseTable = 'treatment_use';
  static const String medicationSideEffectsTable = 'medication_side_effects';
  static const String userAchievementTable = 'user_achievement';
}
