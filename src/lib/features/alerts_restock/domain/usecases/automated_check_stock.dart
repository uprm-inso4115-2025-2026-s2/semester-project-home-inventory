import 'package:src/features/core_inventory/domain/entities/inventory.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';
import 'package:src/features/alerts_restock/domain/entities/stock_status.dart';
import 'package:src/features/alerts_restock/domain/usecases/check_stock.dart';

/// Checks the stock status of all items in the inventory and returns an [StockCheckResult]
/// object with one list of the low stock [StockEntity] and one list of the out of stock 
/// [StockEntity].


class StockCheckResult {
  final List<StockEntity> lowStockItems;
  final List<StockEntity> outOfStockItems;

  StockCheckResult({
    required this.lowStockItems,
    required this.outOfStockItems,
  });
  
}

StockCheckResult automatedCheckStock(InventoryEntity inventory){
  final List<StockEntity> lowStockItems = [];
  final List<StockEntity> outOfStockItems = [];

// iterate through all stock items in the inventory and check their quantity status
  for(var entry in inventory.stock.entries){
    final stock = entry.value;
    for(var item in stock){
      final status = checkStock(currentStock: item.quantity);
      if(status == StockStatus.lowStock){
        lowStockItems.add(item);
        }
      else if(status == StockStatus.outOfStock){
        outOfStockItems.add(item);
      }  
      }
    }
  return StockCheckResult(lowStockItems:lowStockItems, outOfStockItems:outOfStockItems);
  }
