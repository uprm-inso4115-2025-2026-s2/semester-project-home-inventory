import 'package:src/features/sharing_budget/data/datasources/Invitation_remote_data_source.dart';
import 'package:src/features/sharing_budget/data/datasources/household_remote_data_source.dart';
import 'package:src/features/sharing_budget/data/models/household_member_model.dart';
import 'package:src/features/sharing_budget/data/models/household_model.dart';
import 'package:src/features/sharing_budget/data/models/invite_model.dart';
import 'package:src/features/sharing_budget/domain/entities/enums.dart';
import 'package:src/features/sharing_budget/domain/entities/household_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/household_member_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/invite_entity.dart';
import 'package:src/features/sharing_budget/domain/repositories/sharing_repository.dart';

class SharingRepositoryImpl implements SharingRepository {
  final HouseholdRemoteDataSource householdRemoteDataSource;
  final InvitationRemoteDataSource invitationRemoteDataSource;

  const SharingRepositoryImpl({
    required this.householdRemoteDataSource,
    required this.invitationRemoteDataSource,
  });

  @override
  Future<HouseholdEntity> createHousehold(HouseholdEntity household) async {
    final model = HouseholdModel.fromEntity(household);
    final created = await householdRemoteDataSource.createHousehold(model);
    return created.toEntity();
  }

  @override
  Future<HouseholdEntity?> getHouseholdById(int id) async {
    final result = await householdRemoteDataSource.fetchHouseholdById(id);
    return result?.toEntity();
  }

  @override
  Future<List<HouseholdMemberEntity>> getMembersByHousehold(int householdId) async {
    final result =
        await householdRemoteDataSource.fetchMembersByHousehold(householdId);
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<HouseholdMemberEntity> addMember(HouseholdMemberEntity member) async {
    final model = HouseholdMemberModel.fromEntity(member);
    final created = await householdRemoteDataSource.createMember(model);
    return created.toEntity();
  }

  @override
  Future<void> removeMember(int memberId) async {
    await householdRemoteDataSource.removeMember(memberId);
  }

  @override
  Future<InviteEntity> sendInvite(InviteEntity invite) async {
    final model = InviteModel.fromEntity(invite);
    final created = await invitationRemoteDataSource.createInvite(model);
    return created.toEntity();
  }

  @override
  Future<InviteEntity?> getInviteById(int id) async {
    final result = await invitationRemoteDataSource.fetchInviteById(id);
    return result?.toEntity();
  }

  @override
  Future<List<InviteEntity>> getInvitesByHousehold(int householdId) async {
    final result =
        await invitationRemoteDataSource.fetchInvitesByHousehold(householdId);
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<InviteEntity> updateInviteStatus(
    int inviteId,
    InviteStatus status,
  ) async {
    final updated = await invitationRemoteDataSource.updateInviteStatus(
      inviteId,
      status,
    );
    return updated.toEntity();
  }
}