import '../entities/enums.dart';
import '../repositories/sharing_repository.dart';

/// Use case for validating if a user belongs to a household.
///
/// Optionally validates the member role against a list of allowed roles.
class ValidateHouseholdMembership {
  final SharingRepository repository;

  const ValidateHouseholdMembership(this.repository);

  Future<bool> call({
    required int householdId,
    required int userId,
    List<MemberRole> allowedRoles = const [],
  }) async {
    if (householdId <= 0) {
      throw Exception('Household ID must be a positive number');
    }

    if (userId <= 0) {
      throw Exception('User ID must be a positive number');
    }

    final members = await repository.getMembersByHousehold(householdId);

    for (final member in members) {
      if (member.userId == userId) {
        if (allowedRoles.isEmpty) {
          return true;
        }

        return allowedRoles.contains(member.role);
      }
    }

    return false;
  }
}
