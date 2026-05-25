import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/core_inventory/domain/usecases/get_inventory_items.dart';
import '../../fakes/fake_inventory_repository.dart';
import '../../fixtures/core_inventory_test_fixtures.dart';

void main() {
  group('GetInventoryItems', () {
    late FakeInventoryRepository fakeRepository;
    late GetInventoryItems useCase;

    setUp(() {
      fakeRepository = FakeInventoryRepository();
      useCase = GetInventoryItems(fakeRepository);
    });

    tearDown(() {
      fakeRepository.clear();
    });

    test('returns inventory when called with valid ownerId', () async {
      // Arrange
      final testInventory = CoreInventoryTestFixtures.testInventory;
      await fakeRepository.createInventory(testInventory);

      // Act
      final result = await useCase(testInventory.ownerId);

      // Assert
      expect(result, isNotNull);
      expect(result.ownerId, testInventory.ownerId);
      expect(result.id, testInventory.id);
    });

    test('throws exception when inventory not found', () async {
      // Act & Assert
      expect(
        () => useCase(999),
        throwsException,
      );
    });

    test('returns correct inventory with multiple products', () async {
      // Arrange
      final testInventory = CoreInventoryTestFixtures.createTestInventory(
        ownerId: 100,
        stock: {
          CoreInventoryTestFixtures.testProduct: [CoreInventoryTestFixtures.testStock],
          CoreInventoryTestFixtures.testProduct2: [CoreInventoryTestFixtures.testStock2],
        },
      );
      await fakeRepository.createInventory(testInventory);

      // Act
      final result = await useCase(100);

      // Assert
      expect(result.stock.length, 2);
      expect(result.stock.keys.map((p) => p.id).toList(), [1, 2]);
    });
  });
}
