import 'package:src/features/core_inventory/data/models/stock.dart';
import 'package:src/features/core_inventory/domain/entities/inventory.dart';
import 'package:src/features/core_inventory/domain/entities/product.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';

class InventoryModel {
  final int id;

  // This owner id is the id of the room or home that the inventory belongs to
  final int ownerId;

  /// Here the String is the id of the product, and the List is the list of stock of that product
  final Map<String, List<StockModel>> stock;

  const InventoryModel({
    required this.id,
    required this.ownerId,
    required this.stock,
  });

  factory InventoryModel.fromEntity(InventoryEntity entity) {
    return InventoryModel(
      id: entity.id,
      ownerId: entity.ownerId,
      stock: {
        for (var entry in entity.stock.entries)
          entry.key.id.toString(): entry.value
              .map((stock) => StockModel.fromEntity(stock))
              .toList(),
      },
    );
  }

  /// The stock here should be provided by the repository that assembles this aggregate
  InventoryEntity toEntity(Map<ProductEntity, List<StockEntity>> stock) {
    return InventoryEntity(id: id, ownerId: ownerId, stock: stock);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'stock': stock.map(
        (key, value) =>
            MapEntry(key, value.map((stock) => stock.toJson()).toList()),
      ),
    };
  }

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    final stock = json['stock'] as Map<String, dynamic>? ?? {};
    return InventoryModel(
      id: json['id'] as int,
      ownerId: json['ownerId'] as int,
      stock: stock.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map(
                (stock) => StockModel.fromJson(stock as Map<String, dynamic>),
              )
              .toList(),
        ),
      ),
    );
  }

  factory InventoryModel.initial() {
    return InventoryModel(id: -1, ownerId: -1, stock: {});
  }
}
