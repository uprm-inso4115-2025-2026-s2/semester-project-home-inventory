import 'package:src/features/sharing_budget/domain/entities/enums.dart';
import 'package:src/features/sharing_budget/domain/entities/spend_event_entity.dart';

class SpendEventModel extends SpendEventEntity {
  const SpendEventModel({
    required super.id,
    required super.userId,
    required super.householdId,
    required super.productId,
    required super.amount,
    required super.date,
    required super.source,
    super.receiptId,
  });

  factory SpendEventModel.fromEntity(SpendEventEntity entity) {
    return SpendEventModel(
      id: entity.id,
      userId: entity.userId,
      householdId: entity.householdId,
      productId: entity.productId,
      amount: entity.amount,
      date: entity.date,
      source: entity.source,
      receiptId: entity.receiptId,
    );
  }

  SpendEventEntity toEntity() {
    return this as SpendEventEntity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'household_id': householdId,
      'product_id': productId,
      'amount': amount,
      'date': date.toIso8601String(),
      'source': source.name,
      'receipt_id': receiptId,
    };
  }

  factory SpendEventModel.fromJson(Map<String, dynamic> json) {
    return SpendEventModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      householdId: json['household_id'] as int,
      productId: json['product_id'] as int,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      source: SpendSource.values.firstWhere((s) => s.name == json['source']),
      receiptId: json['receipt_id'] as String?,
    );
  }

  factory SpendEventModel.initial() {
    return SpendEventModel(
      id: -1,
      userId: -1,
      householdId: -1,
      productId: -1,
      amount: 0.0,
      date: DateTime.now(),
      source: SpendSource.manual,
    );
  }
}
