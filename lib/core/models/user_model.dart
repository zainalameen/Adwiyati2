class UserModel {
  final String userId;
  final String firstName;
  final String lastName;
  final DateTime dob;
  final String gender;
  final String? bloodType;
  final double? weightKg;
  final bool? smoker;
  final bool? pregnant;
  final int totalPoints;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActionDate;
  final int level;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    this.bloodType,
    this.weightKg,
    this.smoker,
    this.pregnant,
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActionDate,
    this.level = 1,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      dob: DateTime.parse(json['dob'] as String),
      gender: json['gender'] as String,
      bloodType: json['blood_type'] as String?,
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      smoker: json['smoker'] as bool?,
      pregnant: json['pregnant'] as bool?,
      totalPoints: (json['total_points'] as num?)?.toInt() ?? 0,
      currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longest_streak'] as num?)?.toInt() ?? 0,
      lastActionDate: json['last_action_date'] != null
          ? DateTime.parse(json['last_action_date'] as String)
          : null,
      level: (json['level'] as num?)?.toInt() ?? 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'dob': dob.toIso8601String().split('T').first,
      'gender': gender,
      'blood_type': bloodType,
      'weight_kg': weightKg,
      'smoker': smoker,
      'pregnant': pregnant,
      'total_points': totalPoints,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'last_action_date': lastActionDate?.toIso8601String(),
      'level': level,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? firstName,
    String? lastName,
    DateTime? dob,
    String? gender,
    String? bloodType,
    double? weightKg,
    bool? smoker,
    bool? pregnant,
    int? totalPoints,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActionDate,
    int? level,
    DateTime? updatedAt,
  }) {
    return UserModel(
      userId: userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      weightKg: weightKg ?? this.weightKg,
      smoker: smoker ?? this.smoker,
      pregnant: pregnant ?? this.pregnant,
      totalPoints: totalPoints ?? this.totalPoints,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActionDate: lastActionDate ?? this.lastActionDate,
      level: level ?? this.level,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullName => '$firstName $lastName';
}
