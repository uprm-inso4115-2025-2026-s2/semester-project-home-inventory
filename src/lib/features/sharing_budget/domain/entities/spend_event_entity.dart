import 'package:src/features/sharing_budget/domain/entities/enums.dart';

class SpendEventEntity {
  final int id;
  final int userId;
  final int householdId;
  final int productId;
  final double amount;
  final DateTime date;
  final SpendSource source;
  final String? receiptId;

  const SpendEventEntity({
    required this.id,
    required this.userId,
    required this.householdId,
    required this.productId,
    required this.amount,
    required this.date,
    required this.source,
    this.receiptId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SpendEventEntity) return false;
    return id == other.id &&
        userId == other.userId &&
        householdId == other.householdId &&
        productId == other.productId &&
        amount == other.amount &&
        date == other.date &&
        source == other.source &&
        receiptId == other.receiptId;
  }

  @override
  int get hashCode => id.hashCode;
}
