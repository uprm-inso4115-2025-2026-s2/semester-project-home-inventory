import 'package:src/features/sharing_budget/domain/entities/spend_event_entity.dart';
import 'package:src/features/sharing_budget/domain/repositories/budget_repository.dart';

class GetSpendEventsByUserUseCase {
  final BudgetRepository _repository;

  GetSpendEventsByUserUseCase(this._repository);

  Future<List<SpendEventEntity>> call(int userId) {
    return _repository.getSpendEventsByUser(userId);
  }
}