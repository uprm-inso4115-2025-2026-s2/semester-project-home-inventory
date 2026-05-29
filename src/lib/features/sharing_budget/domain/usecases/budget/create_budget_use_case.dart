import 'package:src/features/sharing_budget/domain/entities/budget_entity.dart';
import 'package:src/features/sharing_budget/domain/repositories/budget_repository.dart';

class CreateBudgetUseCase {
  final BudgetRepository _repository;

  CreateBudgetUseCase(this._repository);

  Future<BudgetEntity> call(BudgetEntity budget) {
    return _repository.createBudget(budget);
  }
}