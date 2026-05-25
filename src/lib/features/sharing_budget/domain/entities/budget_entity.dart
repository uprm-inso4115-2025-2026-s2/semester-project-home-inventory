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

  // Rolling window: the period ends the day before the same date in the next cycle.
  // Known edge case: if startDate falls on a day that does not exist in the next
  // month (e.g., Jan 31 monthly), Dart's DateTime overflows to the following month.
  // Resolution for this edge case is tracked in IC-08 of inconsistency-detection.adoc.
  DateTime get computedEndDate {
    switch (period) {
      case BudgetPeriod.weekly:
        return startDate.add(const Duration(days: 6));
      case BudgetPeriod.monthly:
        return DateTime(startDate.year, startDate.month + 1, startDate.day)
            .subtract(const Duration(days: 1));
      case BudgetPeriod.yearly:
        return DateTime(startDate.year + 1, startDate.month, startDate.day)
            .subtract(const Duration(days: 1));
    }
  }

  // Returns true if [date] falls within this budget's active window (inclusive).
  // Time-of-day is ignored; only the calendar date is compared.
  // Domain invariant (IC-09): a SpendEventEntity contributes to this budget if
  // spendEvent.householdId == householdId && covers(spendEvent.date).
  bool covers(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(
      computedEndDate.year,
      computedEndDate.month,
      computedEndDate.day,
    );
    return !day.isBefore(start) && !day.isAfter(end);
  }

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
