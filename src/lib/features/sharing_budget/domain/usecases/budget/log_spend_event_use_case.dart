import 'package:src/features/sharing_budget/domain/entities/budget_allocation_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/spend_event_entity.dart';
import 'package:src/features/sharing_budget/domain/repositories/budget_repository.dart';

class LogSpendEventUseCase {
  final BudgetRepository _repository;

  LogSpendEventUseCase(this._repository);

  /// Creates a [SpendEventEntity] and persists each of its [allocations].
  /// Returns the created event alongside the saved allocation records.
  Future<({SpendEventEntity event, List<BudgetAllocationEntity> allocations})>
      call({
    required SpendEventEntity event,
    List<BudgetAllocationEntity> allocations = const [],
  }) async {
    final createdEvent = await _repository.createSpendEvent(event);

    final createdAllocations = await Future.wait<BudgetAllocationEntity>(
      allocations.map(
        (a) => _repository.createAllocation(
          BudgetAllocationEntity(
            id: a.id,
            spendEventId: createdEvent.id,
            userId: a.userId,
            allocatedAmount: a.allocatedAmount,
            splitMode: a.splitMode,
          ),
        ),
      ),
    );

    return (event: createdEvent, allocations: createdAllocations);
  }
}