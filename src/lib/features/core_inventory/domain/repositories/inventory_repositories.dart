import '../entities/inventory.dart';
import '../entities/product.dart';
import '../entities/stock.dart';
import '../entities/enums.dart';

//Acts as a contract between domain and data layers, following Clean Architecture principles by:
//Using only entities, no implementation details and does not depend on external imports

abstract class InventoryRepository {

  // Inventory operations
  Future<InventoryEntity> getInventoryByOwnerId(int ownerId);

  //Creating a new inventory for the specified owner 
  //Parameter inventory: inventory entity to create and includes owner ID
  Future<InventoryEntity> createInventory(InventoryEntity inventory);

  //Updating a specific inventory for the specified owner 
  Future<InventoryEntity> updateInventory(InventoryEntity inventory);
   
  // Stock operations
  //Parameter inventoryID is the ID of the inventory containing the product
  //Parameter productID is the ID of the product to add stock to 
  //Parameter stock is the stock entity to add
  //Adds stock to a specific product within the a specific inventory
  Future<StockEntity> addStock(int inventoryID, int productId, StockEntity stock);

  //Updates stock for a specific product within a specific inventory
  Future<StockEntity> updateStock(int inventoryID, int productID, StockEntity stock);
  
  //Deletes stock from a specific product within a specific inventory
  Future<void> deleteStock(int inventoryID, int productID, int stockId);

  //Gets all stock for a specific product within a specific inventory
  Future<List<StockEntity>> getStockForProduct(int inventoryID, int productId);

}
