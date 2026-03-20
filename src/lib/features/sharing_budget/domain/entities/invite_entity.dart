import 'package:src/features/sharing_budget/domain/entities/enums.dart';

class InviteEntity {
  final int id;
  final int householdId;
  final int invitedByUserId;
  final String invitedEmail;
  final InviteStatus status;
  final DateTime createdAt;
  final DateTime expiresAt;

  const InviteEntity({
    required this.id,
    required this.householdId,
    required this.invitedByUserId,
    required this.invitedEmail,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InviteEntity) return false;
    return id == other.id &&
        householdId == other.householdId &&
        invitedByUserId == other.invitedByUserId &&
        invitedEmail == other.invitedEmail &&
        status == other.status &&
        createdAt == other.createdAt &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode => id.hashCode;
}
