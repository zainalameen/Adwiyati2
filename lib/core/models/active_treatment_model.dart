enum TreatmentStatus { active, completed }

extension TreatmentStatusX on TreatmentStatus {
  String get value => name;

  static TreatmentStatus fromString(String s) {
    return TreatmentStatus.values.firstWhere((e) => e.name == s);
  }
}

class ActiveTreatmentModel {
  final String treatmentId;
  final String userId;
  final String medicationId;
  final DateTime startDate;
  final DateTime? endDate;
  final int timesPerDay;
  final int intervalDays;
  final double currentQuantity;
  final int pillsTakenSoFar;
  final int? pillsToTake;
  final DateTime expiryDate;
  final TreatmentStatus status;

  const ActiveTreatmentModel({
    required this.treatmentId,
    required this.userId,
    required this.medicationId,
    required this.startDate,
    this.endDate,
    this.timesPerDay = 1,
    this.intervalDays = 1,
    required this.currentQuantity,
    this.pillsTakenSoFar = 0,
    this.pillsToTake,
    required this.expiryDate,
    required this.status,
  });

  factory ActiveTreatmentModel.fromJson(Map<String, dynamic> json) {
    return ActiveTreatmentModel(
      treatmentId: json['treatment_id'] as String,
      userId: json['user_id'] as String,
      medicationId: json['medication_id'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      timesPerDay: (json['times_per_day'] as num?)?.toInt() ?? 1,
      intervalDays: (json['interval_days'] as num?)?.toInt() ?? 1,
      currentQuantity: (json['current_quantity'] as num).toDouble(),
      pillsTakenSoFar: (json['pills_taken_so_far'] as num?)?.toInt() ?? 0,
      pillsToTake: (json['pills_to_take'] as num?)?.toInt(),
      expiryDate: DateTime.parse(json['expiry_date'] as String),
      status: TreatmentStatusX.fromString(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'treatment_id': treatmentId,
      'user_id': userId,
      'medication_id': medicationId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'times_per_day': timesPerDay,
      'interval_days': intervalDays,
      'current_quantity': currentQuantity,
      'pills_taken_so_far': pillsTakenSoFar,
      'pills_to_take': pillsToTake,
      'expiry_date': expiryDate.toIso8601String().split('T').first,
      'status': status.value,
    };
  }

  ActiveTreatmentModel copyWith({
    DateTime? endDate,
    int? timesPerDay,
    int? intervalDays,
    double? currentQuantity,
    int? pillsTakenSoFar,
    int? pillsToTake,
    DateTime? expiryDate,
    TreatmentStatus? status,
  }) {
    return ActiveTreatmentModel(
      treatmentId: treatmentId,
      userId: userId,
      medicationId: medicationId,
      startDate: startDate,
      endDate: endDate ?? this.endDate,
      timesPerDay: timesPerDay ?? this.timesPerDay,
      intervalDays: intervalDays ?? this.intervalDays,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      pillsTakenSoFar: pillsTakenSoFar ?? this.pillsTakenSoFar,
      pillsToTake: pillsToTake ?? this.pillsToTake,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
    );
  }
}
