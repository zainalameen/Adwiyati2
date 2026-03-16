class MedicationSideEffectModel {
  final String sideEffectId;
  final String medicationId;
  final String sideEffect;

  const MedicationSideEffectModel({
    required this.sideEffectId,
    required this.medicationId,
    required this.sideEffect,
  });

  factory MedicationSideEffectModel.fromJson(Map<String, dynamic> json) {
    return MedicationSideEffectModel(
      sideEffectId: json['side_effect_id'] as String,
      medicationId: json['medication_id'] as String,
      sideEffect: json['side_effect'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'side_effect_id': sideEffectId,
      'medication_id': medicationId,
      'side_effect': sideEffect,
    };
  }
}
