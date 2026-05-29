import '../entities/invite_entity.dart';
import '../repositories/sharing_repository.dart';

/// Use case for retrieving all invitations for a household.
class GetHouseholdInvites {
  final SharingRepository repository;

  const GetHouseholdInvites(this.repository);

  Future<List<InviteEntity>> call(int householdId) async {
    if (householdId <= 0) {
      throw Exception('Household ID must be a positive number');
    }

    return repository.getInvitesByHousehold(householdId);
  }
}
