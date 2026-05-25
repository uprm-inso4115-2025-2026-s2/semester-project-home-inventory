import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:src/features/core_inventory/presentation/cubits/inventory_cubit.dart';
import 'package:src/features/core_inventory/presentation/cubits/inventory_state.dart';
import '../../fakes/fake_inventory_repository.dart';
import '../../fixtures/core_inventory_test_fixtures.dart';

// Mock usecases manually since we don't have all the imports
import 'package:src/features/core_inventory/domain/usecases/get_inventory_items.dart';
import 'package:src/features/core_inventory/domain/usecases/get_inventory_items_by_identifier.dart';
import 'package:src/features/core_inventory/domain/usecases/add_inventory_item.dart';
import 'package:src/features/core_inventory/domain/usecases/update_inventory_item.dart';
import 'package:src/features/core_inventory/domain/usecases/delete_inventory_item.dart';

void main() {
  group('InventoryCubit', () {
    late FakeInventoryRepository fakeRepository;
    late GetInventoryItems getInventoryItems;
    late GetInventoryItemsByIdentifier getInventoryItemsByIdentifier;
    late AddInventoryItem addInventoryItem;
    late UpdateInventoryItem updateInventoryItem;
    late DeleteInventoryItem deleteInventoryItem;
    late InventoryCubit inventoryCubit;

    setUp(() async {
      fakeRepository = FakeInventoryRepository();

      getInventoryItems = GetInventoryItems(fakeRepository);
      getInventoryItemsByIdentifier = GetInventoryItemsByIdentifier(fakeRepository);
      addInventoryItem = AddInventoryItem(fakeRepository);
      updateInventoryItem = UpdateInventoryItem(fakeRepository);
      deleteInventoryItem = DeleteInventoryItem(fakeRepository);

      inventoryCubit = InventoryCubit(
        getInventoryItems: getInventoryItems,
        getInventoryItemsByIdentifier: getInventoryItemsByIdentifier,
        addInventoryItem: addInventoryItem,
        updateInventoryItem: updateInventoryItem,
        deleteInventoryItem: deleteInventoryItem,
      );

      // Pre-populate with test inventory
      await fakeRepository.createInventory(CoreInventoryTestFixtures.testInventory);
    });

    tearDown(() {
      inventoryCubit.close();
      fakeRepository.clear();
    });

    blocTest<InventoryCubit, InventoryState>(
      'emits [InventoryLoading, InventoryLoaded] when loadInventory succeeds',
      build: () => inventoryCubit,
      act: (cubit) => cubit.loadInventory(CoreInventoryTestFixtures.testInventory.ownerId),
      expect: () => [
        isA<InventoryLoading>(),
        isA<InventoryLoaded>(),
      ],
    );

    blocTest<InventoryCubit, InventoryState>(
      'emits InventoryLoaded with correct inventory data',
      build: () => inventoryCubit,
      act: (cubit) => cubit.loadInventory(CoreInventoryTestFixtures.testInventory.ownerId),
      verify: (cubit) {
        expect(cubit.state, isA<InventoryLoaded>());
        final loaded = cubit.state as InventoryLoaded;
        expect(loaded.inventory.ownerId, CoreInventoryTestFixtures.testInventory.ownerId);
      },
    );

    blocTest<InventoryCubit, InventoryState>(
      'emits [InventoryLoading, InventoryError] when loadInventory fails',
      build: () => inventoryCubit,
      act: (cubit) => cubit.loadInventory(999), // Non-existent owner
      expect: () => [
        isA<InventoryLoading>(),
        isA<InventoryError>(),
      ],
    );

    blocTest<InventoryCubit, InventoryState>(
      'adds stock and refreshes inventory',
      build: () => inventoryCubit,
      act: (cubit) async {
        await cubit.loadInventory(CoreInventoryTestFixtures.testInventory.ownerId);
        await cubit.addStock(
          CoreInventoryTestFixtures.testInventory.id,
          CoreInventoryTestFixtures.testProduct.id,
          CoreInventoryTestFixtures.createTestStock(id: 2, brand: 'New'),
        );
      },
      verify: (cubit) {
        expect(cubit.state, isA<InventoryLoaded>());
        final loaded = cubit.state as InventoryLoaded;
        final stockList = loaded.inventory.stock[CoreInventoryTestFixtures.testProduct];
        expect(stockList?.length, 2);
      },
    );
  });
}
