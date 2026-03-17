class HouseholdMemberModel {
  final int id;
  final int userId;
  final int householdId;
  final String role;
  final DateTime createdAt;

  const HouseholdMemberModel({
    required this.id,
    required this.userId,
    required this.householdId,
    required this.role,
    required this.createdAt,
  });

  factory HouseholdMemberModel.fromMap(Map<String, dynamic> map) {
    return HouseholdMemberModel(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      householdId: map['household_id'] as int,
      role: map['role'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'household_id': householdId,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }
}