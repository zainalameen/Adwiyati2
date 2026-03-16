import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/allergy_condition_model.dart';
import '../core/models/user_model.dart';
import 'supabase_service.dart';

/// Service layer for creating / reading / updating the user health profile
/// and fetching the allergies & conditions lookup table.
class ProfileService {
  ProfileService._();
  static final instance = ProfileService._();

  // ── User profile CRUD ──────────────────────────────────────────────────

  /// Returns the profile for [userId], or `null` if it doesn't exist yet.
  Future<UserModel?> getProfile(String userId) async {
    final res = await SupabaseService.db
        .from(SupabaseService.userProfileTable)
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    if (res == null) return null;
    return UserModel.fromJson(res);
  }

  /// Inserts a new profile row (called after sign-up health-profile flow).
  Future<void> createProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required DateTime dob,
    required String gender,
    String? bloodType,
    double? weightKg,
    bool smoker = false,
    bool pregnant = false,
  }) async {
    await SupabaseService.db.from(SupabaseService.userProfileTable).insert({
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'dob': dob.toIso8601String().split('T').first,
      'gender': gender,
      'blood_type': bloodType,
      'weight_kg': weightKg,
      'smoker': smoker,
      'pregnant': pregnant,
    });
  }

  /// Updates an existing profile (FR4).
  Future<void> updateProfile(
      String userId, Map<String, dynamic> updates) async {
    updates['updated_at'] = DateTime.now().toIso8601String();
    await SupabaseService.db
        .from(SupabaseService.userProfileTable)
        .update(updates)
        .eq('user_id', userId);
  }

  // ── Allergies & Conditions lookup ──────────────────────────────────────

  Future<List<AllergyConditionModel>> getAllergiesAndConditions() async {
    final res = await SupabaseService.db
        .from(SupabaseService.allergiesConditionsTable)
        .select()
        .order('type')
        .order('name');
    return (res as List)
        .map((e) => AllergyConditionModel.fromJson(e))
        .toList();
  }

  /// Fetches the IDs of the user's selected allergies/conditions.
  Future<List<String>> getUserAllergyConditionIds(String userId) async {
    final res = await SupabaseService.db
        .from(SupabaseService.userAllergiesConditionsTable)
        .select('allergy_condition_id')
        .eq('user_id', userId);
    return (res as List)
        .map((e) => e['allergy_condition_id'] as String)
        .toList();
  }

  /// Sets the user's allergy/condition associations (replaces existing).
  Future<void> setUserAllergiesAndConditions(
    String userId,
    List<String> allergyConditionIds,
  ) async {
    // Delete existing
    await SupabaseService.db
        .from(SupabaseService.userAllergiesConditionsTable)
        .delete()
        .eq('user_id', userId);

    if (allergyConditionIds.isEmpty) return;

    // Insert new
    final rows = allergyConditionIds
        .map((id) => {'user_id': userId, 'allergy_condition_id': id})
        .toList();
    await SupabaseService.db
        .from(SupabaseService.userAllergiesConditionsTable)
        .insert(rows);
  }
}

// ── Riverpod providers ──────────────────────────────────────────────────────

final profileServiceProvider =
    Provider<ProfileService>((_) => ProfileService.instance);

/// Fetches the current user's profile (null when missing).
final userProfileProvider = FutureProvider<UserModel?>((ref) async {
  final user = SupabaseService.auth.currentUser;
  if (user == null) return null;
  return ref.watch(profileServiceProvider).getProfile(user.id);
});

/// Fetches all allergies & conditions from the lookup table.
final allergiesConditionsProvider =
    FutureProvider<List<AllergyConditionModel>>((ref) async {
  return ref.watch(profileServiceProvider).getAllergiesAndConditions();
});

/// Fetches the current user's selected allergy/condition IDs.
final userAllergyConditionIdsProvider =
    FutureProvider<List<String>>((ref) async {
  final user = SupabaseService.auth.currentUser;
  if (user == null) return [];
  return ref.watch(profileServiceProvider).getUserAllergyConditionIds(user.id);
});
