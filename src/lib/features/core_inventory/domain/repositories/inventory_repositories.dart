import '../entities/inventory.dart';
import '../entities/product.dart';
import '../entities/stock.dart';
import '../entities/enums.dart';


//Acts as a contract between domain and data layers, following Clean Architecture principles by:
//Using only entities, no implementation details and does not depend on external imports

abstract class InventoryRepository {

  // Inventory operations
  Future<InventoryEntity> getInventoryByOwnerId(int ownerId);
  Future<InventoryEntity> createInventory(int ownerId);
  Future<InventoryEntity> updateInventory(InventoryEntity inventory);
  
  // Product operations
  Future<ProductEntity> addProduct(ProductEntity product);
  Future<ProductEntity> updateProduct(ProductEntity product);
  Future<void> deleteProduct(int productId);
  Future<List<ProductEntity>> getAllProducts();
  Future<List<ProductEntity>> searchProducts(String query, {List<Tag>? tags});
  
  // Stock operations
  Future<StockEntity> addStock(int productId, StockEntity stock);
  Future<StockEntity> updateStock(StockEntity stock);
  Future<void> deleteStock(int stockId);
  Future<List<StockEntity>> getStockForProduct(int productId);

}
