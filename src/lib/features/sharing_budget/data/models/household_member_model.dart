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
    return HouseholdMemberEntity(
      id: id,
      householdId: householdId,
      userId: userId,
      role: role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'household_id': householdId,
      'user_id': userId,
      'role': role.name,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  factory HouseholdMemberModel.fromMap(Map<String, dynamic> map) {
    return HouseholdMemberModel(
      id: map['id'] as int,
      householdId: map['household_id'] as int,
      userId: map['user_id'] as int,
      role: MemberRole.values.firstWhere((r) => r.name == map['role']),
    );
  }

  factory HouseholdMemberModel.fromJson(Map<String, dynamic> json) =>
      HouseholdMemberModel.fromMap(json);

  factory HouseholdMemberModel.initial() {
    return const HouseholdMemberModel(
      id: -1,
      householdId: -1,
      userId: -1,
      role: MemberRole.viewer,
    );
  }
}
