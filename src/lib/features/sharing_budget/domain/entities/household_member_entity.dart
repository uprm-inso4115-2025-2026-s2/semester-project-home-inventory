import 'package:src/features/sharing_budget/domain/entities/enums.dart';

class HouseholdMemberEntity {
  final int id;
  final int householdId;
  final int userId;
  final MemberRole role;

  const HouseholdMemberEntity({
    required this.id,
    required this.householdId,
    required this.userId,
    required this.role,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HouseholdMemberEntity) return false;
    return id == other.id &&
        householdId == other.householdId &&
        userId == other.userId &&
        role == other.role;
  }

  @override
  int get hashCode => id.hashCode;
}
