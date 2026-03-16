class CabinetMedModel {
  final String cabinetMedId;
  final String userId;
  final String medicationId;
  final double quantity;
  final DateTime expirationDate;
  final bool expAlertSent;

  const CabinetMedModel({
    required this.cabinetMedId,
    required this.userId,
    required this.medicationId,
    required this.quantity,
    required this.expirationDate,
    this.expAlertSent = false,
  });

  factory CabinetMedModel.fromJson(Map<String, dynamic> json) {
    return CabinetMedModel(
      cabinetMedId: json['cabinet_med_id'] as String,
      userId: json['user_id'] as String,
      medicationId: json['medication_id'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      expirationDate: DateTime.parse(json['expiration_date'] as String),
      expAlertSent: (json['exp_alert_sent'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cabinet_med_id': cabinetMedId,
      'user_id': userId,
      'medication_id': medicationId,
      'quantity': quantity,
      'expiration_date': expirationDate.toIso8601String().split('T').first,
      'exp_alert_sent': expAlertSent,
    };
  }

  CabinetMedModel copyWith({
    double? quantity,
    DateTime? expirationDate,
    bool? expAlertSent,
  }) {
    return CabinetMedModel(
      cabinetMedId: cabinetMedId,
      userId: userId,
      medicationId: medicationId,
      quantity: quantity ?? this.quantity,
      expirationDate: expirationDate ?? this.expirationDate,
      expAlertSent: expAlertSent ?? this.expAlertSent,
    );
  }

  bool get isExpiringSoon {
    final daysUntilExpiry = expirationDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry >= 0;
  }

  bool get isExpired => expirationDate.isBefore(DateTime.now());
}
