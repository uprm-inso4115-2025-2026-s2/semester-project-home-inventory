import 'package:src/features/sharing_budget/domain/entities/spend_event_entity.dart';
import 'package:src/features/sharing_budget/domain/repositories/budget_repository.dart';

class GetSpendEventsByHouseholdUseCase {
  final BudgetRepository _repository;

  GetSpendEventsByHouseholdUseCase(this._repository);

  Future<List<SpendEventEntity>> call(int householdId) {
    return _repository.getSpendEventsByHousehold(householdId);
  }
}