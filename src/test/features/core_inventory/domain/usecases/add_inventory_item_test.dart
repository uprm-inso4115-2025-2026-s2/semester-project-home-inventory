import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/core_inventory/domain/usecases/add_inventory_item.dart';
import 'package:src/features/core_inventory/domain/entities/enums.dart';
import '../../fakes/fake_inventory_repository.dart';
import '../../fixtures/core_inventory_test_fixtures.dart';

void main() {
  group('AddInventoryItem', () {
    late FakeInventoryRepository fakeRepository;
    late AddInventoryItem useCase;

    setUp(() {
      fakeRepository = FakeInventoryRepository();
      useCase = AddInventoryItem(fakeRepository);
    });

    tearDown(() {
      fakeRepository.clear();
    });

    test('adds stock to an existing product in inventory', () async {
      // Arrange
      final testInventory = CoreInventoryTestFixtures.testInventory;
      await fakeRepository.createInventory(testInventory);

      final newStock = CoreInventoryTestFixtures.createTestStock(
        id: 2,
        brand: 'New Brand',
        quantity: 15,
      );

      // Act
      await useCase(
        testInventory.id,
        CoreInventoryTestFixtures.testProduct.id,
        newStock,
      );

      // Assert
      final inventory = await fakeRepository.getInventoryByOwnerId(testInventory.ownerId);
      final stockList = inventory.stock[CoreInventoryTestFixtures.testProduct]!;
      expect(stockList.length, 2);
      expect(stockList.last.brand, 'New Brand');
    });

    test('throws exception when inventory not found', () async {
      // Act & Assert
      expect(
        () => useCase(999, 1, CoreInventoryTestFixtures.testStock),
        throwsException,
      );
    });

    test('throws exception when product not found', () async {
      // Arrange
      final testInventory = CoreInventoryTestFixtures.testInventory;
      await fakeRepository.createInventory(testInventory);

      // Act & Assert
      expect(
        () => useCase(
          testInventory.id,
          999,
          CoreInventoryTestFixtures.testStock,
        ),
        throwsException,
      );
    });

    test('rejects stock with negative quantity', () async {
      // Arrange
      final testInventory = CoreInventoryTestFixtures.testInventory;
      await fakeRepository.createInventory(testInventory);

      final invalidStock = CoreInventoryTestFixtures.createTestStock(
        quantity: -5,
      );

      // Act & Assert
      expect(
        () => useCase(
          testInventory.id,
          CoreInventoryTestFixtures.testProduct.id,
          invalidStock,
        ),
        throwsException,
      );
    });

    test('rejects stock with empty brand', () async {
      // Arrange
      final testInventory = CoreInventoryTestFixtures.testInventory;
      await fakeRepository.createInventory(testInventory);

      final invalidStock = CoreInventoryTestFixtures.createTestStock(
        brand: '',
      );

      // Act & Assert
      expect(
        () => useCase(
          testInventory.id,
          CoreInventoryTestFixtures.testProduct.id,
          invalidStock,
        ),
        throwsException,
      );
    });
  });
}
