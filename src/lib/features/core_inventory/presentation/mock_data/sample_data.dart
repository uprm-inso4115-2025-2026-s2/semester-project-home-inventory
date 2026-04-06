import 'package:src/features/core_inventory/domain/entities/enums.dart';
import 'package:src/features/core_inventory/domain/entities/inventory.dart';
import 'package:src/features/core_inventory/domain/entities/product.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';

InventoryEntity buildSampleInventory() {
  const rice = ProductEntity(
    id: 1,
    name: 'Rice',
    description: 'Long grain rice',
    tags: [Tag.EDIBLE, Tag.ORGANIC],
    unit: 'bags',
  );

  const beans = ProductEntity(
    id: 2,
    name: 'Beans',
    description: 'Canned beans',
    tags: [Tag.EDIBLE, Tag.ORGANIC],
    unit: 'cans',
  );

  const milk = ProductEntity(
    id: 3,
    name: 'Milk',
    description: 'Whole milk',
    tags: [Tag.EDIBLE, Tag.REFRIGERATED],
    unit: 'cartons',
  );

  const bread = ProductEntity(
    id: 4,
    name: 'Bread',
    description: 'Sliced bread',
    tags: [Tag.EDIBLE],
    unit: 'loaves',
  );

  const eggs = ProductEntity(
    id: 5,
    name: 'Eggs',
    description: 'Chicken eggs',
    tags: [Tag.EDIBLE, Tag.FRAGILE, Tag.REFRIGERATED],
    unit: 'dozens',
  );

  const soap = ProductEntity(
    id: 6,
    name: 'Soap',
    description: 'Dish soap',
    tags: [Tag.CLEANING, Tag.LIQUID],
    unit: 'bottles',
  );

  return InventoryEntity(
    id: 1,
    ownerId: 1,
    stock: {
      rice: [
        StockEntity(
          id: 1,
          brand: 'Goya',
          quantity: 5,
          status: Status.FULL,
          expirationDate: DateTime(2026, 8, 15),
        ),
      ],
      beans: [
        StockEntity(
          id: 2,
          brand: 'Del Monte',
          quantity: 3,
          status: Status.HALFWAY,
          expirationDate: DateTime(2026, 7, 1),
        ),
      ],
      milk: [
        StockEntity(
          id: 3,
          brand: 'Tres Monjitas',
          quantity: 1,
          status: Status.LOW,
          expirationDate: DateTime(2026, 4, 3),
        ),
      ],
      bread: [
        StockEntity(
          id: 4,
          brand: 'Bimbo',
          quantity: 1,
          status: Status.LOW,
          expirationDate: DateTime(2026, 4, 1),
        ),
      ],
      eggs: [
        StockEntity(
          id: 5,
          brand: 'Store Brand',
          quantity: 0,
          status: Status.EMPTY,
        ),
      ],
      soap: [
        StockEntity(id: 6, brand: 'Dawn', quantity: 2, status: Status.UNKNOWN),
      ],
    },
  );
}

String inventoryCategoryTitle(String categoryId) {
  switch (categoryId) {
    case 'in_stock':
      return 'In Stock';
    case 'low_stock':
      return 'Low Stock';
    case 'out_of_stock':
      return 'Out of Stock';
    case 'custom':
      return 'Category';
    default:
      return 'Category';
  }
}

List<ProductEntity> filterProductsForCategory(
  InventoryEntity inventory,
  String categoryId,
) {
  final products = inventory.stock.keys.toList();

  switch (categoryId) {
    case 'in_stock':
      return products.where((product) {
        final stocks = inventory.stock[product] ?? const <StockEntity>[];
        return stocks.any(
          (stock) =>
              stock.status == Status.FULL || stock.status == Status.HALFWAY,
        );
      }).toList();

    case 'low_stock':
      return products.where((product) {
        final stocks = inventory.stock[product] ?? const <StockEntity>[];
        return stocks.any((stock) => stock.status == Status.LOW);
      }).toList();

    case 'out_of_stock':
      return products.where((product) {
        final stocks = inventory.stock[product] ?? const <StockEntity>[];
        return stocks.any((stock) => stock.status == Status.EMPTY);
      }).toList();

    default:
      return products;
  }
}

MapEntry<ProductEntity, StockEntity>? findProductAndStockByStockId(
  InventoryEntity inventory,
  int stockId,
) {
  for (final entry in inventory.stock.entries) {
    for (final stock in entry.value) {
      if (stock.id == stockId) {
        return MapEntry(entry.key, stock);
      }
    }
  }
  return null;
}
