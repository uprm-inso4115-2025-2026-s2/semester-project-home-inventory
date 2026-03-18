import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/alerts_restock/domain/usecases/automated_check_stock.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';
import 'package:src/features/core_inventory/domain/entities/enums.dart';
import 'package:src/features/core_inventory/domain/entities/product.dart';
import 'package:src/features/core_inventory/domain/entities/inventory.dart';


void main(){

//different stock items with varying quantities to test all scenarios
  final inStockItem = StockEntity(
    id: 1,
    brand: 'TestBrand',
    quantity: 10,
    status: Status.FULL,
  ); 
  final lowStockItem = StockEntity(
    id: 2,
    brand: 'TestBrand',
    quantity: 4,
    status: Status.FULL,
  );
  //Tests when a stock is right on the threshold of low stock, which according to the stock status logic, should be treated as low stock
  final thresholdItem = StockEntity(
    id: 4,
    brand: 'TestBrand',
    quantity: 5,
    status: Status.FULL,
  );
  //Tests when a quantity is negative, which should be treated as in stock, according to stock status logic
  final negativeItem = StockEntity(
    id: 5,
    brand: 'TestBrand',
    quantity: -1,
    status: Status.FULL,
  );
  final outOfStockItem = StockEntity(
    id: 3,
    brand: 'TestBrand',
    quantity: 0,
    status: Status.FULL,
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
      product: [lowStockItem, inStockItem, outOfStockItem, thresholdItem, negativeItem],
    },
  );
  final emptyInventory = InventoryEntity(
    id: 2,
    ownerId: 2,
    stock: {},
  );
  test('automatedCheckStock correctly identifies low stock and out of stock items', (){
    final result = automatedCheckStock(inventory);

    expect(result.lowStockItems, contains(lowStockItem));
    expect(result.lowStockItems, contains(thresholdItem));
    expect(result.lowStockItems.length, 2); // two low stock items

    expect(result.outOfStockItems, contains(outOfStockItem));
    expect(result.outOfStockItems.length, 1); // only one out of stock item

    //ignores the rest of the items since they are considered in stock
    expect(result.lowStockItems, isNot(contains(inStockItem)));
    expect(result.outOfStockItems, isNot(contains(inStockItem)));
    expect(result.outOfStockItems, isNot(contains(negativeItem)));
    expect(result.lowStockItems, isNot(contains(negativeItem)));
  });
   test('returns empty list when inventory is empty',(){
    final result = automatedCheckStock(emptyInventory);

    expect(result.lowStockItems, isEmpty);
    expect(result.outOfStockItems, isEmpty);
  });

}