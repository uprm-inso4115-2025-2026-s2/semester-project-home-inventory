import 'package:src/features/core_inventory/domain/entities/enums.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';

class StockModel extends StockEntity {
  const StockModel({
    required super.id,
    required super.brand,
    required super.quantity,
    required super.status,
    super.ownerId,
    super.expirationDate,
  });

  factory StockModel.fromEntity(StockEntity entity) {
    return StockModel(
      id: entity.id,
      brand: entity.brand,
      quantity: entity.quantity,
      status: entity.status,
      ownerId: entity is StockModel ? entity.ownerId : entity.ownerId,
      expirationDate: entity.expirationDate,
    );
  }

  StockEntity toEntity() {
    return StockEntity(
      id: id,
      brand: brand,
      quantity: quantity,
      status: status,
      ownerId: ownerId,
      expirationDate: expirationDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'quantity': quantity,
      'status': status.name,
      if (ownerId != null) 'ownerId': ownerId,
      'expirationDate': expirationDate?.toIso8601String(),
    };
  }

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['id'] as int,
      brand: json['brand'] as String,
      quantity: json['quantity'] as int,
      status: Status.values.firstWhere((s) => s.name == json['status']),
      ownerId: json['ownerId'] is int
          ? json['ownerId'] as int
          : (json['ownerId'] is String
                ? int.tryParse(json['ownerId'] as String)
                : null),
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
      ownerId: null,
      expirationDate: DateTime.now(),
    );
  }
}
