import 'package:src/features/sharing_budget/domain/entities/budget_allocation_entity.dart';
import 'package:src/features/sharing_budget/domain/repositories/budget_repository.dart';

class GetAllocationsBySpendEventUseCase {
  final BudgetRepository _repository;

  GetAllocationsBySpendEventUseCase(this._repository);

  Future<List<BudgetAllocationEntity>> call(int spendEventId) {
    return _repository.getAllocationsBySpendEvent(spendEventId);
  }
}