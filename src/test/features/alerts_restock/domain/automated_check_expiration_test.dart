import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/alerts_restock/domain/usecases/automated_check_expiration.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';
import 'package:src/features/core_inventory/domain/entities/enums.dart';
import 'package:src/features/core_inventory/domain/entities/product.dart';
import 'package:src/features/core_inventory/domain/entities/inventory.dart';


void main(){
// fixed date used to simulate "today" during tests
  final baseDate = DateTime(2026, 3, 10);
//different stock items with varying expiration dates to test all scenarios
  final nearExpirationItem = StockEntity(
    id: 1,
    brand: 'TestBrand',
    quantity: 10,
    status: Status.FULL,
    expirationDate: DateTime(2026, 3, 15), // within 7 days threshold
  ); 
  final expiredItem = StockEntity(
    id: 2,
    brand: 'TestBrand',
    quantity: 5,
    status: Status.FULL,
    expirationDate: DateTime(2026, 3, 9), // past date
  );
  final okItem = StockEntity(
    id: 3,
    brand: 'TestBrand',
    quantity: 20,
    status: Status.FULL,
    expirationDate: DateTime(2026, 3, 20), // beyond threshold
  );
  //Tests when stock expires on the same day
  final sameDayExpirationItem = StockEntity(
    id: 4,
    brand: 'TestBrand',
    quantity: 20,
    status: Status.FULL,
    expirationDate: DateTime(2026, 3, 10), // same day as base date
  );
  final product = ProductEntity(
    id: 1,
    name: 'TestProduct',
    description: 'TestCategory',
  );
  final inventory = InventoryEntity(
    id: 1,
    ownerId: 1,
    stock: {
      product: [nearExpirationItem, expiredItem, okItem, sameDayExpirationItem],
    },
  );
  final emptyInventory = InventoryEntity(
    id: 2,
    ownerId: 2,
    stock: {},
  );
  
  test('automatedCheckExpiration correctly identifies expired and near expiration items', (){
    final result = automatedCheckExpiration(inventory, baseDate);

    expect(result.expiredItems, contains(expiredItem));
    expect(result.expiredItems, contains(sameDayExpirationItem));
    expect(result.expiredItems.length, 2); // two expired items

    expect(result.nearExpirationItems, contains(nearExpirationItem));
    expect(result.nearExpirationItems.length, 1); // only one near expiration item

    expect(result.expiredItems, isNot(contains(okItem)));
    expect(result.nearExpirationItems, isNot(contains(okItem)));
  });
  test('returns empty list when inventory is empty',(){
    final result = automatedCheckExpiration(emptyInventory, baseDate);

    expect(result.expiredItems, isEmpty);
    expect(result.nearExpirationItems, isEmpty);
  });

}