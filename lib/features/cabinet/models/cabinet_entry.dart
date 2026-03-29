import '../../../core/models/cabinet_med_model.dart';
import '../../../core/models/medication_model.dart';

/// A row in `cabinet_med` with its linked [MedicationModel].
class CabinetEntry {
  final CabinetMedModel cabinet;
  final MedicationModel medication;

  const CabinetEntry({required this.cabinet, required this.medication});

  String get displayName => medication.tradeNameEn;

  String get doseLine {
    final u = medication.unit?.trim();
    final d = medication.doseAmount;
    final s = d == d.roundToDouble() ? d.toInt().toString() : d.toString();
    if (u != null && u.isNotEmpty) return '$s$u';
    return s;
  }

  String get quantityLine {
    final q = cabinet.quantity;
    final whole = q == q.roundToDouble();
    final s = whole ? q.toInt().toString() : q.toString();
    return '$s pieces';
  }

  /// Show alert badge (low stock or expiry risk).
  bool get showAlertBadge =>
      cabinet.isExpired || cabinet.isExpiringSoon || _isLowStock;

  bool get _isLowStock {
    final orig = medication.originalQuantity;
    if (orig <= 0) return cabinet.quantity <= 5;
    return cabinet.quantity <= 5 || cabinet.quantity <= orig * 0.15;
  }

  ExpiryUrgency get expiryUrgency {
    if (cabinet.isExpired) return ExpiryUrgency.expired;
    if (cabinet.isExpiringSoon) return ExpiryUrgency.soon;
    return ExpiryUrgency.normal;
  }
}

enum ExpiryUrgency { normal, soon, expired }
