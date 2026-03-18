import 'package:src/features/core_inventory/domain/entities/enums.dart';

class StockEntity {
  final int id;
  final String brand;
  final int quantity;
  final Status status;
  final DateTime? expirationDate;

  const StockEntity({
    required this.id,
    required this.brand,
    required this.quantity,
    required this.status,
    this.expirationDate,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! StockEntity) return false;
    return id == other.id &&
        brand == other.brand &&
        quantity == other.quantity &&
        status == other.status &&
        expirationDate == other.expirationDate;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
