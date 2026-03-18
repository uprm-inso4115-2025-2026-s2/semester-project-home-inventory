import 'package:src/features/sharing_budget/domain/entities/budget_allocation_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/budget_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/spend_event_entity.dart';

abstract class BudgetRepository {
  Future<BudgetEntity> createBudget(BudgetEntity budget);
  Future<BudgetEntity?> getBudgetByHousehold(int householdId);
  Future<BudgetEntity> updateBudget(BudgetEntity budget);
  Future<SpendEventEntity> createSpendEvent(SpendEventEntity event);
  Future<List<SpendEventEntity>> getSpendEventsByHousehold(int householdId);
  Future<List<SpendEventEntity>> getSpendEventsByUser(int userId);
  Future<BudgetAllocationEntity> createAllocation(BudgetAllocationEntity allocation);
  Future<List<BudgetAllocationEntity>> getAllocationsBySpendEvent(int spendEventId);
}
