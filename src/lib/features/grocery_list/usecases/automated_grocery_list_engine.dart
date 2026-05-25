import 'package:src/features/core_inventory/domain/entities/inventory.dart';
import 'package:src/features/core_inventory/domain/entities/product.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';

import 'package:src/features/alerts_restock/domain/entities/expiration_status.dart';
import 'package:src/features/alerts_restock/domain/entities/stock_status.dart';
import 'package:src/features/alerts_restock/domain/usecases/check_expiration.dart';
import 'package:src/features/alerts_restock/domain/usecases/check_stock.dart';

enum GroceryListReason {
  outOfStock,
  expired,
}

enum GroceryListSource {
  automation,
  manual,
}

abstract class GroceryListRepository {
  Future<void> upsertGroceryListItem({
    required int productId,
    required String productName,
    required int quantity,
    required GroceryListReason reason,
    required GroceryListSource source,
  });
}

class AutomatedGroceryEngine {
  final GroceryListRepository groceryListRepository;

  AutomatedGroceryEngine({
    required this.groceryListRepository,
  });

  Future<void> run({
    required InventoryEntity inventory,
    DateTime? currentDate,
  }) async {
    final DateTime dateToUse = currentDate ?? DateTime.now();

    final Set<int> addedProducts = {};

    for (final entry in inventory.stock.entries) {
      final ProductEntity product = entry.key;
      final List<StockEntity> stockItems = entry.value;

      for (final stockItem in stockItems) {
        final stockStatus = checkStock(
          currentStock: stockItem.quantity,
        );

        final expirationStatus = checkExpiration(
          expirationDate: stockItem.expirationDate,
          currentDate: dateToUse,
        );

        final bool shouldAddToGroceryList =
            stockStatus == StockStatus.outOfStock ||
            expirationStatus == ExpirationStatus.expired;

        if (shouldAddToGroceryList && !addedProducts.contains(product.id)) {
          final GroceryListReason reason =
              stockStatus == StockStatus.outOfStock
                  ? GroceryListReason.outOfStock
                  : GroceryListReason.expired;

          await groceryListRepository.upsertGroceryListItem(
            productId: product.id,
            productName: product.name,
            quantity: 1,
            reason: reason,
            source: GroceryListSource.automation,
          );

          addedProducts.add(product.id);
        }
      }
    }
  }
}