class UseCategoryModel {
  final String useId;
  final String name;

  const UseCategoryModel({required this.useId, required this.name});

  factory UseCategoryModel.fromJson(Map<String, dynamic> json) {
    return UseCategoryModel(
      useId: json['use_id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'use_id': useId, 'name': name};
  }
}
