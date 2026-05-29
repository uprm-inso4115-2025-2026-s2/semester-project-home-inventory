import 'package:src/features/sharing_budget/domain/entities/household_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/household_member_entity.dart';
import 'package:src/features/sharing_budget/domain/repositories/sharing_repository.dart';

class GetHouseholdUseCase {
  final SharingRepository _repository;

  GetHouseholdUseCase(this._repository);

  Future<HouseholdEntity?> call(int id) {
    return _repository.getHouseholdById(id);
  }
}

class GetHouseholdMembersUseCase {
  final SharingRepository _repository;

  GetHouseholdMembersUseCase(this._repository);

  Future<List<HouseholdMemberEntity>> call(int householdId) {
    return _repository.getMembersByHousehold(householdId);
  }
}

class AddMemberUseCase {
  final SharingRepository _repository;

  AddMemberUseCase(this._repository);

  Future<HouseholdMemberEntity> call(HouseholdMemberEntity member) {
    return _repository.addMember(member);
  }
}

class RemoveMemberUseCase {
  final SharingRepository _repository;

  RemoveMemberUseCase(this._repository);

  Future<void> call(int memberId) {
    return _repository.removeMember(memberId);
  }
}