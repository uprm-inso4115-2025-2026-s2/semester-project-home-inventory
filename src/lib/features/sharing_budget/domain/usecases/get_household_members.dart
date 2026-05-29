import '../entities/household_member_entity.dart';
import '../repositories/sharing_repository.dart';

/// Use case for retrieving all members that belong to a household.
class GetHouseholdMembers {
  final SharingRepository repository;

  const GetHouseholdMembers(this.repository);

  Future<List<HouseholdMemberEntity>> call(int householdId) async {
    if (householdId <= 0) {
      throw Exception('Household ID must be a positive number');
    }

    return repository.getMembersByHousehold(householdId);
  }
}
