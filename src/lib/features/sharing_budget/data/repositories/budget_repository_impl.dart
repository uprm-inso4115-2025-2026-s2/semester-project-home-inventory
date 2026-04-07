import 'package:src/features/sharing_budget/data/datasources/budget_remote_data_source.dart';
import 'package:src/features/sharing_budget/data/datasources/expense_remote_data_source.dart';
import 'package:src/features/sharing_budget/data/models/budget_allocation_model.dart';
import 'package:src/features/sharing_budget/data/models/budget_model.dart';
import 'package:src/features/sharing_budget/data/models/spend_event_model.dart';
import 'package:src/features/sharing_budget/domain/entities/budget_allocation_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/budget_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/spend_event_entity.dart';
import 'package:src/features/sharing_budget/domain/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource budgetRemoteDataSource;
  final ExpenseRemoteDataSource expenseRemoteDataSource;

  const BudgetRepositoryImpl({
    required this.budgetRemoteDataSource,
    required this.expenseRemoteDataSource,
  });

  @override
  Future<BudgetEntity> createBudget(BudgetEntity budget) async {
    final model = BudgetModel.fromEntity(budget);
    final created = await budgetRemoteDataSource.createBudget(model);
    return created.toEntity();
  }

  @override
  Future<BudgetEntity?> getBudgetByHousehold(int householdId) async {
    final result =
        await budgetRemoteDataSource.fetchBudgetByHousehold(householdId);
    return result?.toEntity();
  }

  @override
  Future<BudgetEntity> updateBudget(BudgetEntity budget) async {
    final model = BudgetModel.fromEntity(budget);

    final updated = await budgetRemoteDataSource.updateBudget(
      model.id,
      {
        'household_id': model.householdId,
        'limit_amount': model.limitAmount,
        'period': model.period.name,
        'start_date': model.startDate.toIso8601String(),
      },
    );

    return updated.toEntity();
  }

  @override
  Future<SpendEventEntity> createSpendEvent(SpendEventEntity event) async {
    final model = SpendEventModel.fromEntity(event);
    final created = await expenseRemoteDataSource.createSpendEvent(model);
    return created.toEntity();
  }

  @override
  Future<List<SpendEventEntity>> getSpendEventsByHousehold(int householdId) async {
    final result =
        await expenseRemoteDataSource.fetchSpendEventsByHousehold(householdId);
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<SpendEventEntity>> getSpendEventsByUser(int userId) async {
    final result = await expenseRemoteDataSource.fetchSpendEventsByUser(userId);
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<BudgetAllocationEntity> createAllocation(
    BudgetAllocationEntity allocation,
  ) async {
    final model = BudgetAllocationModel.fromEntity(allocation);
    final created = await budgetRemoteDataSource.createAllocation(model);
    return created.toEntity();
  }

  @override
  Future<List<BudgetAllocationEntity>> getAllocationsBySpendEvent(
    int spendEventId,
  ) async {
    final result = await budgetRemoteDataSource
        .fetchAllocationsBySpendEvent(spendEventId);
    return result.map((e) => e.toEntity()).toList();
  }
}