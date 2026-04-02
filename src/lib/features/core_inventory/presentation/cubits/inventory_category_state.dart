import 'package:src/features/core_inventory/domain/entities/inventory.dart';
import 'package:src/features/core_inventory/domain/entities/product.dart';

class InventoryCategoryState {
  final String categoryId;
  final String title;
  final InventoryEntity inventory;
  final List<ProductEntity> products;

  const InventoryCategoryState({
    required this.categoryId,
    required this.title,
    required this.inventory,
    required this.products,
  });
}
