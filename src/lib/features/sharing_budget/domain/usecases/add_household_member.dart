import '../entities/household_member_entity.dart';
import '../repositories/sharing_repository.dart';

/// Use case for adding a user as a household member.
///
/// Includes duplicate prevention so the same user cannot be added
/// to the same household more than once.
class AddHouseholdMember {
  final SharingRepository repository;

  const AddHouseholdMember(this.repository);

  Future<HouseholdMemberEntity> call(HouseholdMemberEntity member) async {
    if (member.householdId <= 0) {
      throw Exception('Household ID must be a positive number');
    }

    if (member.userId <= 0) {
      throw Exception('User ID must be a positive number');
    }

    final existingMembers = await repository.getMembersByHousehold(
      member.householdId,
    );

    final alreadyMember = existingMembers
        .whereType<HouseholdMemberEntity>()
        .any((existingMember) => existingMember.userId == member.userId);

    if (alreadyMember) {
      throw Exception('User is already a member of this household');
    }

    return repository.addMember(member);
  }
}
