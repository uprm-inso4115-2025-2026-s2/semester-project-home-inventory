import 'package:src/features/sharing_budget/domain/entities/budget_entity.dart';
import 'package:src/features/sharing_budget/domain/repositories/budget_repository.dart';

class UpdateBudgetUseCase {
  final BudgetRepository _repository;

  UpdateBudgetUseCase(this._repository);

  Future<BudgetEntity> call(BudgetEntity budget) {
    return _repository.updateBudget(budget);
  }
}