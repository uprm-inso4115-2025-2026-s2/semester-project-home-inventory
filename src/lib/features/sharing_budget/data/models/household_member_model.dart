import 'package:src/features/sharing_budget/domain/entities/enums.dart';
import 'package:src/features/sharing_budget/domain/entities/household_member_entity.dart';

class HouseholdMemberModel extends HouseholdMemberEntity {
  const HouseholdMemberModel({
    required super.id,
    required super.householdId,
    required super.userId,
    required super.role,
  });

  factory HouseholdMemberModel.fromEntity(HouseholdMemberEntity entity) {
    return HouseholdMemberModel(
      id: entity.id,
      householdId: entity.householdId,
      userId: entity.userId,
      role: entity.role,
    );
  }

  HouseholdMemberEntity toEntity() {
    return this as HouseholdMemberEntity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'household_id': householdId,
      'user_id': userId,
      'role': role.name,
    };
  }

  factory HouseholdMemberModel.fromJson(Map<String, dynamic> json) {
    return HouseholdMemberModel(
      id: json['id'] as int,
      householdId: json['household_id'] as int,
      userId: json['user_id'] as int,
      role: MemberRole.values.firstWhere((r) => r.name == json['role']),
    );
  }

  factory HouseholdMemberModel.initial() {
    return const HouseholdMemberModel(
      id: -1,
      householdId: -1,
      userId: -1,
      role: MemberRole.viewer,
    );
  }
}
