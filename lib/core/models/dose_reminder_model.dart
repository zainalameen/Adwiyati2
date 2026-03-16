enum DoseReminderStatus { pending, taken, skipped }

extension DoseReminderStatusX on DoseReminderStatus {
  String get value => name;

  static DoseReminderStatus fromString(String s) {
    return DoseReminderStatus.values.firstWhere((e) => e.name == s);
  }
}

class DoseReminderModel {
  final String reminderId;
  final String treatmentId;
  final DateTime plannedDate;
  final String plannedTime;
  final String? actualTime;
  final double quantityToTake;
  final DoseReminderStatus status;

  const DoseReminderModel({
    required this.reminderId,
    required this.treatmentId,
    required this.plannedDate,
    required this.plannedTime,
    this.actualTime,
    required this.quantityToTake,
    required this.status,
  });

  factory DoseReminderModel.fromJson(Map<String, dynamic> json) {
    return DoseReminderModel(
      reminderId: json['reminder_id'] as String,
      treatmentId: json['treatment_id'] as String,
      plannedDate: DateTime.parse(json['planned_date'] as String),
      plannedTime: json['planned_time'] as String,
      actualTime: json['actual_time'] as String?,
      quantityToTake: (json['quantity_to_take'] as num).toDouble(),
      status: DoseReminderStatusX.fromString(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reminder_id': reminderId,
      'treatment_id': treatmentId,
      'planned_date': plannedDate.toIso8601String().split('T').first,
      'planned_time': plannedTime,
      'actual_time': actualTime,
      'quantity_to_take': quantityToTake,
      'status': status.value,
    };
  }

  DoseReminderModel copyWith({
    String? actualTime,
    DoseReminderStatus? status,
  }) {
    return DoseReminderModel(
      reminderId: reminderId,
      treatmentId: treatmentId,
      plannedDate: plannedDate,
      plannedTime: plannedTime,
      actualTime: actualTime ?? this.actualTime,
      quantityToTake: quantityToTake,
      status: status ?? this.status,
    );
  }
}
