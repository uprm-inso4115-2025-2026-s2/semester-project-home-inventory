class InviteTokenModel {
  final int id;
  final int householdId;
  final String token;
  final DateTime? expiresAt;
  final DateTime? usedAt;
  final DateTime createdAt;

  const InviteTokenModel({
    required this.id,
    required this.householdId,
    required this.token,
    this.expiresAt,
    this.usedAt,
    required this.createdAt,
  });

  factory InviteTokenModel.fromMap(Map<String, dynamic> map) {
    return InviteTokenModel(
      id: map['id'] as int,
      householdId: map['household_id'] as int,
      token: map['token'] as String,
      expiresAt: map['expires_at'] != null
          ? DateTime.parse(map['expires_at'] as String)
          : null,
      usedAt: map['used_at'] != null
          ? DateTime.parse(map['used_at'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'household_id': householdId,
      'token': token,
      'expires_at': expiresAt?.toIso8601String(),
      'used_at': usedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}