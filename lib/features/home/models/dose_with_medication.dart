import '../../../core/models/dose_reminder_model.dart';

class DoseWithMedication {
  final String reminderId;
  final String treatmentId;
  final DateTime plannedDate;
  final String plannedTime;
  final String? actualTime;
  final double quantityToTake;
  final DoseReminderStatus status;
  final String medicationName;
  final String medicationNameAr;
  final String dosageForm;
  final double doseAmount;
  final String? unit;
  final String? doseInstructions;

  const DoseWithMedication({
    required this.reminderId,
    required this.treatmentId,
    required this.plannedDate,
    required this.plannedTime,
    this.actualTime,
    required this.quantityToTake,
    required this.status,
    required this.medicationName,
    required this.medicationNameAr,
    required this.dosageForm,
    required this.doseAmount,
    this.unit,
    this.doseInstructions,
  });

  String get timeCategory {
    final parts = plannedTime.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    if (hour < 11) return 'After Breakfast';
    if (hour < 15) return 'After Lunch';
    if (hour < 19) return 'After Dinner';
    return 'Before Bed';
  }

  String get formattedTime {
    final parts = plannedTime.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts.length > 1 ? parts[1] : '00';
    final period = hour >= 12 ? 'PM' : 'AM';
    final h12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${h12.toString().padLeft(2, '0')}:$minute $period';
  }

  String get dosageDisplay {
    final amt = doseAmount % 1 == 0
        ? doseAmount.toInt().toString()
        : '$doseAmount';
    return unit != null ? '$amt$unit' : amt;
  }

  DoseWithMedication copyWith({
    DoseReminderStatus? status,
    String? actualTime,
  }) {
    return DoseWithMedication(
      reminderId: reminderId,
      treatmentId: treatmentId,
      plannedDate: plannedDate,
      plannedTime: plannedTime,
      actualTime: actualTime ?? this.actualTime,
      quantityToTake: quantityToTake,
      status: status ?? this.status,
      medicationName: medicationName,
      medicationNameAr: medicationNameAr,
      dosageForm: dosageForm,
      doseAmount: doseAmount,
      unit: unit,
      doseInstructions: doseInstructions,
    );
  }
}
