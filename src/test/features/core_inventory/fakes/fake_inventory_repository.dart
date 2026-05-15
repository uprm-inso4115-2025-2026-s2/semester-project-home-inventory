import 'package:src/features/core_inventory/domain/entities/inventory.dart';
import 'package:src/features/core_inventory/domain/entities/product.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';
import 'package:src/features/core_inventory/domain/repositories/inventory_repositories.dart';

/// A fake implementation of InventoryRepository for testing.
class FakeInventoryRepository implements InventoryRepository {
  final Map<int, InventoryEntity> _inventories = {};
  int _nextInventoryId = 1;

  @override
  Future<InventoryEntity> getInventoryByOwnerId(int ownerId) async {
    final inv = _inventories.values.firstWhere(
      (inv) => inv.ownerId == ownerId,
      orElse: () => throw Exception('Inventory not found for owner $ownerId'),
    );
    return inv;
  }

  @override
  Future<InventoryEntity> getInventoryByOwnerIdentifier(String ownerIdentifier) async {
    final inv = _inventories.values.firstWhere(
      (inv) => inv.ownerId.toString() == ownerIdentifier,
      orElse: () => throw Exception('Inventory not found for owner $ownerIdentifier'),
    );
    return inv;
  }

  @override
  Future<InventoryEntity> createInventory(InventoryEntity inventory) async {
    final newInv = InventoryEntity(
      id: _nextInventoryId++,
      ownerId: inventory.ownerId,
      stock: inventory.stock,
    );
    _inventories[newInv.id] = newInv;
    return newInv;
  }

  @override
  Future<InventoryEntity> updateInventory(InventoryEntity inventory) async {
    _inventories[inventory.id] = inventory;
    return inventory;
  }

  @override
  Future<StockEntity> addStock(int inventoryId, int productId, StockEntity stock) async {
    final inv = _inventories[inventoryId];
    if (inv == null) throw Exception('Inventory not found');

    final product = inv.stock.keys.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Product not found'),
    );

    inv.stock[product]?.add(stock);
    return stock;
  }

  @override
  Future<StockEntity> updateStock(int inventoryId, int productId, StockEntity stock) async {
    final inv = _inventories[inventoryId];
    if (inv == null) throw Exception('Inventory not found');

    final product = inv.stock.keys.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Product not found'),
    );

    final stockList = inv.stock[product];
    if (stockList == null) throw Exception('Stock list not found');

    final index = stockList.indexWhere((s) => s.id == stock.id);
    if (index == -1) throw Exception('Stock not found');

    stockList[index] = stock;
    return stock;
  }

  @override
  Future<void> deleteStock(int inventoryId, int productId, int stockId) async {
    final inv = _inventories[inventoryId];
    if (inv == null) throw Exception('Inventory not found');

    final product = inv.stock.keys.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Product not found'),
    );

    inv.stock[product]?.removeWhere((s) => s.id == stockId);
  }

  @override
  Future<List<StockEntity>> getStockForProduct(int inventoryId, int productId) async {
    final inv = _inventories[inventoryId];
    if (inv == null) throw Exception('Inventory not found');

    final product = inv.stock.keys.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Product not found'),
    );

    return inv.stock[product] ?? [];
  }

  void clear() => _inventories.clear();
}
