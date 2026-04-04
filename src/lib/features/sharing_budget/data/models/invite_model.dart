import 'package:src/features/sharing_budget/domain/entities/enums.dart';
import 'package:src/features/sharing_budget/domain/entities/invite_entity.dart';

class InviteModel extends InviteEntity {
  const InviteModel({
    required super.id,
    required super.householdId,
    required super.invitedByUserId,
    required super.invitedEmail,
    required super.status,
    required super.createdAt,
    required super.expiresAt,
  });

  factory InviteModel.fromEntity(InviteEntity entity) {
    return InviteModel(
      id: entity.id,
      householdId: entity.householdId,
      invitedByUserId: entity.invitedByUserId,
      invitedEmail: entity.invitedEmail,
      status: entity.status,
      createdAt: entity.createdAt,
      expiresAt: entity.expiresAt,
    );
  }

  InviteEntity toEntity() {
    return this as InviteEntity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'household_id': householdId,
      'invited_by_user_id': invitedByUserId,
      'invited_email': invitedEmail,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  factory InviteModel.fromJson(Map<String, dynamic> json) {
    return InviteModel(
      id: json['id'] as int,
      householdId: json['household_id'] as int,
      invitedByUserId: json['invited_by_user_id'] as int,
      invitedEmail: json['invited_email'] as String,
      status: InviteStatus.values.firstWhere((s) => s.name == json['status']),
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  factory InviteModel.initial() {
    final now = DateTime.now();
    return InviteModel(
      id: -1,
      householdId: -1,
      invitedByUserId: -1,
      invitedEmail: '',
      status: InviteStatus.pending,
      createdAt: now,
      expiresAt: now.add(const Duration(days: 7)),
    );
  }
}
