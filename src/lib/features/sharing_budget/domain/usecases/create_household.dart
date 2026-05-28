import '../entities/household_entity.dart';
import '../repositories/sharing_repository.dart';

/// Use case for creating a household.
///
/// Keeps household creation logic in the domain/application layer
/// instead of allowing the presentation layer to call the repository directly.
class CreateHousehold {
  final SharingRepository repository;

  const CreateHousehold(this.repository);

  Future<HouseholdEntity> call(HouseholdEntity household) async {
    if (household.name.trim().isEmpty) {
      throw Exception('Household name cannot be empty');
    }

    if (household.ownerId <= 0) {
      throw Exception('Owner ID must be a positive number');
    }

    return repository.createHousehold(household);
  }
}
