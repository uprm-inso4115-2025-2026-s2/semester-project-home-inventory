import 'package:src/features/core_inventory/domain/entities/enums.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';

class StockModel extends StockEntity {
  const StockModel({
    required super.id,
    required super.brand,
    required super.quantity,
    required super.status,
    super.expirationDate,
  });

  factory StockModel.fromEntity(StockEntity entity) {
    return entity as StockModel;
  }

  StockEntity toEntity() {
    return this as StockEntity;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'quantity': quantity,
      'status': status.name,
      'expirationDate': expirationDate?.toIso8601String(),
    };
  }

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['id'] as int,
      brand: json['brand'] as String,
      quantity: json['quantity'] as int,
      status: Status.values.firstWhere((s) => s.name == json['status']),
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'])
          : null,
    );
  }

  factory StockModel.initial() {
    return StockModel(
      id: -1,
      brand: '',
      quantity: 0,
      status: Status.EMPTY,
      expirationDate: DateTime.now(),
    );
  }
}
