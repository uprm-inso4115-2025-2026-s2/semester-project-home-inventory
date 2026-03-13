import 'package:src/features/core_inventory/domain/entities/product.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';

class InventoryEntity {
  final int id;
  final int ownerId;
  final Map<ProductEntity, List<StockEntity>> stock;

  const InventoryEntity({
    required this.id,
    required this.ownerId,
    required this.stock,
  });
}
