import 'package:src/features/sharing_budget/domain/entities/budget_allocation_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/enums.dart';

class BudgetAllocationModel extends BudgetAllocationEntity {
  const BudgetAllocationModel({
    required super.id,
    required super.spendEventId,
    required super.userId,
    required super.allocatedAmount,
    required super.splitMode,
  });

  factory BudgetAllocationModel.fromEntity(BudgetAllocationEntity entity) {
    return BudgetAllocationModel(
      id: entity.id,
      spendEventId: entity.spendEventId,
      userId: entity.userId,
      allocatedAmount: entity.allocatedAmount,
      splitMode: entity.splitMode,
    );
  }

  BudgetAllocationEntity toEntity() {
    return this as BudgetAllocationEntity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spend_event_id': spendEventId,
      'user_id': userId,
      'allocated_amount': allocatedAmount,
      'split_mode': splitMode.name,
    };
  }

  factory BudgetAllocationModel.fromJson(Map<String, dynamic> json) {
    return BudgetAllocationModel(
      id: json['id'] as int,
      spendEventId: json['spend_event_id'] as int,
      userId: json['user_id'] as int,
      allocatedAmount: (json['allocated_amount'] as num).toDouble(),
      splitMode: SplitMode.values.firstWhere((s) => s.name == json['split_mode']),
    );
  }

  factory BudgetAllocationModel.initial() {
    return const BudgetAllocationModel(
      id: -1,
      spendEventId: -1,
      userId: -1,
      allocatedAmount: 0.0,
      splitMode: SplitMode.equal,
    );
  }
}
