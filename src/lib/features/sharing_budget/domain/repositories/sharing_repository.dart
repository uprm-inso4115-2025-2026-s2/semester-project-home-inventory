import 'package:src/features/sharing_budget/domain/entities/enums.dart';
import 'package:src/features/sharing_budget/domain/entities/household_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/household_member_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/invite_entity.dart';

abstract class SharingRepository {
  Future<HouseholdEntity> createHousehold(HouseholdEntity household);
  Future<HouseholdEntity?> getHouseholdById(int id);
  Future<List<HouseholdMemberEntity>> getMembersByHousehold(int householdId);
  Future<HouseholdMemberEntity> addMember(HouseholdMemberEntity member);
  Future<void> removeMember(int memberId);
  Future<InviteEntity> sendInvite(InviteEntity invite);
  Future<InviteEntity?> getInviteById(int id);
  Future<List<InviteEntity>> getInvitesByHousehold(int householdId);
  Future<InviteEntity> updateInviteStatus(int inviteId, InviteStatus status);
}
