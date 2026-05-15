import 'package:src/features/core_inventory/domain/entities/inventory.dart';
import 'package:src/features/core_inventory/domain/entities/product.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';
import 'package:src/features/core_inventory/domain/entities/enums.dart';

class CoreInventoryTestFixtures {
  static final testProduct = ProductEntity(
    id: 1,
    name: 'Test Product',
    description: 'A test product',
    unit: 'units',
    imageUrl: null,
  );

  static final testProduct2 = ProductEntity(
    id: 2,
    name: 'Another Product',
    description: 'Another test product',
    unit: 'items',
    imageUrl: null,
  );

  static final testStock = StockEntity(
    id: 1,
    brand: 'Test Brand',
    quantity: 10,
    status: Status.FULL,
    expirationDate: DateTime(2025, 12, 31),
  );

  static final testStock2 = StockEntity(
    id: 2,
    brand: 'Another Brand',
    quantity: 5,
    status: Status.LOW,
    expirationDate: DateTime(2026, 6, 30),
  );

  static final testInventory = InventoryEntity(
    id: 1,
    ownerId: 123,
    stock: {
      testProduct: [testStock],
    },
  );

  static final testInventoryEmpty = InventoryEntity(
    id: 2,
    ownerId: 124,
    stock: {},
  );

  static InventoryEntity createTestInventory({
    int? id,
    int? ownerId,
    Map<ProductEntity, List<StockEntity>>? stock,
  }) {
    return InventoryEntity(
      id: id ?? 1,
      ownerId: ownerId ?? 123,
      stock: stock ?? {testProduct: [testStock]},
    );
  }

  static StockEntity createTestStock({
    int? id,
    String? brand,
    int? quantity,
    Status? status,
    DateTime? expirationDate,
  }) {
    return StockEntity(
      id: id ?? 1,
      brand: brand ?? 'Test Brand',
      quantity: quantity ?? 10,
      status: status ?? Status.FULL,
      expirationDate: expirationDate,
    );
  }
}
