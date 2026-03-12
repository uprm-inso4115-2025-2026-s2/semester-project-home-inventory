import 'package:src/features/sharing_budget/domain/entities/enums.dart';

class BudgetAllocationEntity {
  final int id;
  final int spendEventId;
  final int userId;
  final double allocatedAmount;
  final SplitMode splitMode;

  const BudgetAllocationEntity({
    required this.id,
    required this.spendEventId,
    required this.userId,
    required this.allocatedAmount,
    required this.splitMode,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BudgetAllocationEntity) return false;
    return id == other.id &&
        spendEventId == other.spendEventId &&
        userId == other.userId &&
        allocatedAmount == other.allocatedAmount &&
        splitMode == other.splitMode;
  }

  @override
  int get hashCode => id.hashCode;
}
