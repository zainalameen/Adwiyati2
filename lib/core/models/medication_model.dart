class MedicationModel {
  final String medicationId;
  final String dosageForm;
  final String tradeNameEn;
  final String tradeNameAr;
  final String scientificNameEn;
  final String scientificNameAr;
  final String? doseInstructions;
  final String? otherInstructions;
  final String? storageInstructions;
  final String? barcode;
  final double originalQuantity;
  final double doseAmount;
  final String? unit;

  const MedicationModel({
    required this.medicationId,
    required this.dosageForm,
    required this.tradeNameEn,
    required this.tradeNameAr,
    required this.scientificNameEn,
    required this.scientificNameAr,
    this.doseInstructions,
    this.otherInstructions,
    this.storageInstructions,
    this.barcode,
    required this.originalQuantity,
    required this.doseAmount,
    this.unit,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      medicationId: json['medication_id'] as String,
      dosageForm: json['dosage_form'] as String,
      tradeNameEn: json['trade_name_en'] as String,
      tradeNameAr: json['trade_name_ar'] as String,
      scientificNameEn: json['scientific_name_en'] as String,
      scientificNameAr: json['scientific_name_ar'] as String,
      doseInstructions: json['dose_instructions'] as String?,
      otherInstructions: json['other_instructions'] as String?,
      storageInstructions: json['storage_instructions'] as String?,
      barcode: json['barcode'] as String?,
      originalQuantity: (json['original_quantity'] as num).toDouble(),
      doseAmount: (json['dose_amount'] as num).toDouble(),
      unit: json['unit'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medication_id': medicationId,
      'dosage_form': dosageForm,
      'trade_name_en': tradeNameEn,
      'trade_name_ar': tradeNameAr,
      'scientific_name_en': scientificNameEn,
      'scientific_name_ar': scientificNameAr,
      'dose_instructions': doseInstructions,
      'other_instructions': otherInstructions,
      'storage_instructions': storageInstructions,
      'barcode': barcode,
      'original_quantity': originalQuantity,
      'dose_amount': doseAmount,
      'unit': unit,
    };
  }

  MedicationModel copyWith({
    String? dosageForm,
    String? tradeNameEn,
    String? tradeNameAr,
    String? scientificNameEn,
    String? scientificNameAr,
    String? doseInstructions,
    String? otherInstructions,
    String? storageInstructions,
    String? barcode,
    double? originalQuantity,
    double? doseAmount,
    String? unit,
  }) {
    return MedicationModel(
      medicationId: medicationId,
      dosageForm: dosageForm ?? this.dosageForm,
      tradeNameEn: tradeNameEn ?? this.tradeNameEn,
      tradeNameAr: tradeNameAr ?? this.tradeNameAr,
      scientificNameEn: scientificNameEn ?? this.scientificNameEn,
      scientificNameAr: scientificNameAr ?? this.scientificNameAr,
      doseInstructions: doseInstructions ?? this.doseInstructions,
      otherInstructions: otherInstructions ?? this.otherInstructions,
      storageInstructions: storageInstructions ?? this.storageInstructions,
      barcode: barcode ?? this.barcode,
      originalQuantity: originalQuantity ?? this.originalQuantity,
      doseAmount: doseAmount ?? this.doseAmount,
      unit: unit ?? this.unit,
    );
  }
}
