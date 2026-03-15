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
      product: [lowStockItem, inStockItem, outOfStockItem],
    },
  );
  test('automatedCheckStock correctly identifies low stock and out of stock items', (){
    final result = automatedCheckStock(inventory);

    expect(result.lowStockItems, contains(lowStockItem));
    expect(result.lowStockItems.length, 1); // only one low stock item

    expect(result.outOfStockItems, contains(outOfStockItem));
    expect(result.outOfStockItems.length, 1); // only one out of stock item

    expect(result.lowStockItems, isNot(contains(inStockItem)));
    expect(result.outOfStockItems, isNot(contains(inStockItem)));
  });

}