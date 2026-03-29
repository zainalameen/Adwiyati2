import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/supabase_service.dart';
import '../../../services/cabinet_service.dart';
import '../models/cabinet_entry.dart';

final cabinetListProvider = FutureProvider<List<CabinetEntry>>((ref) async {
  final user = SupabaseService.auth.currentUser;
  if (user == null) return [];
  return CabinetService.instance.listCabinetForUser(user.id);
});

final cabinetDetailProvider = FutureProvider.family<CabinetEntry?, String>((
  ref,
  cabinetMedId,
) async {
  final user = SupabaseService.auth.currentUser;
  if (user == null) return null;
  return CabinetService.instance.getCabinetEntry(cabinetMedId, user.id);
});
