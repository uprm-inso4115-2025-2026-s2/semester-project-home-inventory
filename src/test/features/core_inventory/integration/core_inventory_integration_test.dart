import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/core_inventory/data/data_sources/inventory_supabase_datasource.dart';
import 'package:src/features/core_inventory/data/models/inventory.dart';
import 'package:src/features/core_inventory/data/models/stock.dart';
import 'package:src/features/core_inventory/data/repositories/inventory_repository_impl.dart';
import 'package:src/features/core_inventory/domain/usecases/get_inventory_items.dart';
import 'package:src/features/core_inventory/domain/usecases/add_inventory_item.dart';
import '../fakes/fake_inventory_repository.dart';
import '../fakes/fake_product_repository.dart';
import '../fixtures/core_inventory_test_fixtures.dart';

void main() {
  group('Core Inventory Integration Tests', () {
    late FakeInventoryRepository fakeInventoryRepository;
    late FakeProductRepository fakeProductRepository;
    late GetInventoryItems getInventoryItems;
    late AddInventoryItem addInventoryItem;

    setUp(() {
      fakeInventoryRepository = FakeInventoryRepository();
      fakeProductRepository = FakeProductRepository(
        initialProducts: {
          1: CoreInventoryTestFixtures.testProduct,
          2: CoreInventoryTestFixtures.testProduct2,
        },
      );

      getInventoryItems = GetInventoryItems(fakeInventoryRepository);
      addInventoryItem = AddInventoryItem(fakeInventoryRepository);
    });

    tearDown(() {
      fakeInventoryRepository.clear();
      fakeProductRepository.clear();
    });

    test('full flow: create inventory, add stock, retrieve', () async {
      // Arrange
      final testInventory = CoreInventoryTestFixtures.testInventory;
      await fakeInventoryRepository.createInventory(testInventory);

      // Act 1: Retrieve inventory
      final retrieved = await getInventoryItems(testInventory.ownerId);

      // Assert 1
      expect(retrieved.ownerId, testInventory.ownerId);
      expect(retrieved.stock.isNotEmpty, true);

      // Act 2: Add stock
      final newStock = CoreInventoryTestFixtures.createTestStock(
        id: 99,
        brand: 'Added Brand',
      );
      await addInventoryItem(testInventory.id, 1, newStock);

      // Assert 2
      final updated = await getInventoryItems(testInventory.ownerId);
      final stockList = updated.stock[CoreInventoryTestFixtures.testProduct]!;
      expect(stockList.length, 2);
      expect(stockList.any((s) => s.brand == 'Added Brand'), true);
    });

    test('multiple inventories are independent', () async {
      // Arrange
      final inv1 = CoreInventoryTestFixtures.createTestInventory(
        ownerId: 100,
        id: 1,
      );
      final inv2 = CoreInventoryTestFixtures.createTestInventory(
        ownerId: 101,
        id: 2,
      );

      await fakeInventoryRepository.createInventory(inv1);
      await fakeInventoryRepository.createInventory(inv2);

      // Act
      final retrieved1 = await getInventoryItems(100);
      final retrieved2 = await getInventoryItems(101);

      // Assert - verify different owners are independent
      expect(retrieved1.ownerId, 100);
      expect(retrieved2.ownerId, 101);
      expect(retrieved1.ownerId != retrieved2.ownerId, true);
    });

    test('empty inventory is valid', () async {
      // Arrange
      final emptyInv = CoreInventoryTestFixtures.testInventoryEmpty;
      await fakeInventoryRepository.createInventory(emptyInv);

      // Act
      final retrieved = await getInventoryItems(emptyInv.ownerId);

      // Assert
      expect(retrieved.ownerId, emptyInv.ownerId);
      expect(retrieved.stock.isEmpty, true);
    });
  });
}
