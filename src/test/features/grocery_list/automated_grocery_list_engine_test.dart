import 'package:flutter_test/flutter_test.dart';

import 'package:src/features/grocery_list/usecases/automated_grocery_list_engine.dart';
import 'package:src/features/core_inventory/domain/entities/inventory.dart';
import 'package:src/features/core_inventory/domain/entities/product.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';
import 'package:src/features/core_inventory/domain/entities/enums.dart';

class FakeGroceryListRepository implements GroceryListRepository {
  final List<Map<String, dynamic>> addedItems = [];

  @override
  Future<void> upsertGroceryListItem({
    required int productId,
    required String productName,
    required int quantity,
    required GroceryListReason reason,
    required GroceryListSource source,
  }) async {
    addedItems.add({
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'reason': reason,
      'source': source,
    });
  }
}

void main() {
  test('adds out of stock and expired items to grocery list', () async {
    final milk = ProductEntity(
      id: 1,
      name: 'Milk',
      description: 'Whole milk',
    );

    final eggs = ProductEntity(
      id: 2,
      name: 'Eggs',
      description: 'Large eggs',
    );

    final bread = ProductEntity(
      id: 3,
      name: 'Bread',
      description: 'White bread',
    );

    final inventory = InventoryEntity(
      id: 1,
      ownerId: 1,
      stock: {
        milk: [
          StockEntity(
            id: 1,
            brand: 'Tres Monjitas',
            quantity: 0,
            status: Status.EMPTY,
            expirationDate: DateTime(2026, 5, 20),
          ),
        ],
        eggs: [
          StockEntity(
            id: 2,
            brand: 'Generic',
            quantity: 4,
            status: Status.FULL,
            expirationDate: DateTime(2026, 5, 1),
          ),
        ],
        bread: [
          StockEntity(
            id: 3,
            brand: 'Bimbo',
            quantity: 5,
            status: Status.FULL,
            expirationDate: DateTime(2026, 6, 1),
          ),
        ],
      },
    );

    final fakeRepository = FakeGroceryListRepository();

    final engine = AutomatedGroceryEngine(
      groceryListRepository: fakeRepository,
    );

    await engine.run(
      inventory: inventory,
      currentDate: DateTime(2026, 5, 15),
    );

    expect(fakeRepository.addedItems.length, 2);

    expect(fakeRepository.addedItems[0]['productName'], 'Milk');
    expect(fakeRepository.addedItems[0]['reason'], GroceryListReason.outOfStock);
    expect(fakeRepository.addedItems[0]['source'], GroceryListSource.automation);

    expect(fakeRepository.addedItems[1]['productName'], 'Eggs');
    expect(fakeRepository.addedItems[1]['reason'], GroceryListReason.expired);
    expect(fakeRepository.addedItems[1]['source'], GroceryListSource.automation);
  });
}