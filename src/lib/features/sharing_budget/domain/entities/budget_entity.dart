import 'package:src/features/sharing_budget/domain/entities/enums.dart';

class BudgetEntity {
  final int id;
  final int householdId;
  final double limitAmount;
  final BudgetPeriod period;
  final DateTime startDate;

  const BudgetEntity({
    required this.id,
    required this.householdId,
    required this.limitAmount,
    required this.period,
    required this.startDate,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BudgetEntity) return false;
    return id == other.id &&
        householdId == other.householdId &&
        limitAmount == other.limitAmount &&
        period == other.period &&
        startDate == other.startDate;
  }

  @override
  int get hashCode => id.hashCode;
}
