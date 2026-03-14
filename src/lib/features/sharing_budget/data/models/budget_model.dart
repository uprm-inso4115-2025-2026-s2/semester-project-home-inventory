import 'package:src/features/sharing_budget/domain/entities/budget_entity.dart';
import 'package:src/features/sharing_budget/domain/entities/enums.dart';

class BudgetModel extends BudgetEntity {
  const BudgetModel({
    required super.id,
    required super.householdId,
    required super.limitAmount,
    required super.period,
    required super.startDate,
  });

  factory BudgetModel.fromEntity(BudgetEntity entity) {
    return BudgetModel(
      id: entity.id,
      householdId: entity.householdId,
      limitAmount: entity.limitAmount,
      period: entity.period,
      startDate: entity.startDate,
    );
  }

  BudgetEntity toEntity() {
    return this as BudgetEntity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'household_id': householdId,
      'limit_amount': limitAmount,
      'period': period.name,
      'start_date': startDate.toIso8601String(),
    };
  }

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as int,
      householdId: json['household_id'] as int,
      limitAmount: (json['limit_amount'] as num).toDouble(),
      period: BudgetPeriod.values.firstWhere((p) => p.name == json['period']),
      startDate: DateTime.parse(json['start_date'] as String),
    );
  }

  factory BudgetModel.initial() {
    return BudgetModel(
      id: -1,
      householdId: -1,
      limitAmount: 0.0,
      period: BudgetPeriod.monthly,
      startDate: DateTime.now(),
    );
  }
}
