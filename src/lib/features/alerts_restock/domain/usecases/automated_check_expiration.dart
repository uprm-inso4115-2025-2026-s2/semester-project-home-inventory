import 'package:src/features/core_inventory/domain/entities/inventory.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';
import 'package:src/features/alerts_restock/domain/entities/expiration_status.dart';
import 'package:src/features/alerts_restock/domain/usecases/check_expiration.dart';

/// Checks the expiration status of all items in the inventory and returns an [ExpirationCheckResult]
/// object with one list of the expired [StockEntity] and one list of the near expiration 
/// [StockEntity].


class ExpirationCheckResult {
  final List<StockEntity> expiredItems;
  final List<StockEntity> nearExpirationItems;

  ExpirationCheckResult({
    required this.expiredItems,
    required this.nearExpirationItems,
  });
  
}

//dateTime parameter is used for testing purposes, otherwise the function will use the current date
ExpirationCheckResult automatedCheckExpiration(InventoryEntity inventory, DateTime? currentDate){
  final List<StockEntity> expiredItems = [];
  final List<StockEntity> nearExpirationItems = [];

// iterate through all stock items in the inventory and check their expiration status
  for(var entry in inventory.stock.entries){
    final stock = entry.value;
    for(var item in stock){
      final status = checkExpiration(expirationDate: item.expirationDate, currentDate:currentDate);
      if(status == ExpirationStatus.expired){
        expiredItems.add(item);
        }
      else if(status == ExpirationStatus.nearExpiration){
        nearExpirationItems.add(item);
      }  
      }
    }
  return ExpirationCheckResult(expiredItems:expiredItems, nearExpirationItems:nearExpirationItems);
  }
