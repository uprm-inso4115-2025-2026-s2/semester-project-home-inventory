import 'package:src/features/sharing_budget/domain/entities/household_entity.dart';
import 'package:src/features/sharing_budget/domain/repositories/sharing_repository.dart';

class CreateHouseholdUseCase {
  final SharingRepository _repository;

  CreateHouseholdUseCase(this._repository);

  Future<HouseholdEntity> call(HouseholdEntity household) {
    return _repository.createHousehold(household);
  }
}