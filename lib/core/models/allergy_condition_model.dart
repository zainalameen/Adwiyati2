enum AllergyConditionType { allergy, condition }

extension AllergyConditionTypeX on AllergyConditionType {
  String get value => name == 'allergy' ? 'Allergy' : 'Condition';

  static AllergyConditionType fromString(String s) {
    return s == 'Allergy' ? AllergyConditionType.allergy : AllergyConditionType.condition;
  }
}

class AllergyConditionModel {
  final String allergyConditionId;
  final AllergyConditionType type;
  final String name;
  final String? nameAr;

  const AllergyConditionModel({
    required this.allergyConditionId,
    required this.type,
    required this.name,
    this.nameAr,
  });

  factory AllergyConditionModel.fromJson(Map<String, dynamic> json) {
    return AllergyConditionModel(
      allergyConditionId: json['allergy_condition_id'] as String,
      type: AllergyConditionTypeX.fromString(json['type'] as String),
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allergy_condition_id': allergyConditionId,
      'type': type.value,
      'name': name,
      'name_ar': nameAr,
    };
  }
}
