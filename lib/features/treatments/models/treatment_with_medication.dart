import '../../../core/models/active_treatment_model.dart';
import '../../../core/models/medication_model.dart';

/// Active treatment row joined with its [MedicationModel] for list and detail UIs.
class TreatmentWithMedication {
  final ActiveTreatmentModel treatment;
  final MedicationModel medication;

  const TreatmentWithMedication({
    required this.treatment,
    required this.medication,
  });

  String get displayTitle {
    final unit = medication.unit?.trim();
    final dose = medication.doseAmount;
    final name = medication.tradeNameEn;
    if (unit != null && unit.isNotEmpty) {
      return '$name, ${dose.toString().replaceAll(RegExp(r'\.0$'), '')}$unit';
    }
    return '$name, ${dose.toString().replaceAll(RegExp(r'\.0$'), '')}';
  }

  String get scheduleLabel {
    final t = treatment.timesPerDay;
    final interval = treatment.intervalDays;
    if (interval <= 1) {
      return t == 1 ? 'Once daily' : '$t times daily';
    }
    return '$t times every $interval days';
  }

  String get typeLabel => medication.dosageForm;
}
