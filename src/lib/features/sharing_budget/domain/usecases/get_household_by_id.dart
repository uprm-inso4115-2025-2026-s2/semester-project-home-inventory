import '../entities/household_entity.dart';
import '../repositories/sharing_repository.dart';

/// Use case for retrieving a household by ID.
class GetHouseholdById {
  final SharingRepository repository;

  const GetHouseholdById(this.repository);

  Future<HouseholdEntity?> call(int householdId) async {
    if (householdId <= 0) {
      throw Exception('Household ID must be a positive number');
    }

    return repository.getHouseholdById(householdId);
  }
}
