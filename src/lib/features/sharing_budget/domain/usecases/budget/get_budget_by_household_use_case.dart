import 'package:src/features/sharing_budget/domain/entities/budget_entity.dart';
import 'package:src/features/sharing_budget/domain/repositories/budget_repository.dart';

class GetBudgetByHouseholdUseCase {
  final BudgetRepository _repository;

  GetBudgetByHouseholdUseCase(this._repository);

  Future<BudgetEntity?> call(int householdId) {
    return _repository.getBudgetByHousehold(householdId);
  }
}