import '../entities/stock.dart';
import '../repositories/inventory_repositories.dart';

//use case to update an existing inventory item (stock)

class UpdateInventoryItem {
  final InventoryRepository _repository;

  UpdateInventoryItem(this._repository);

  //[inventoryId] is the ID of the inventory
  //[productId] is the ID of the product containing the stock
  //[stock] is the updated stock entity
  //returns [StockEntity] with the updated stock

  Future<StockEntity> call(int inventoryId, int productId, StockEntity stock) async {
    
    //validation
    if (inventoryId <= 0) {
      throw Exception('Inventory ID must be a positive number');
    }
    if (productId <= 0) {
      throw Exception('Product ID must be a positive number');
    }
    if (stock.id <= 0) {
      throw Exception('Stock ID must be a positive number');
    }
    if (stock.brand.isEmpty) {
      throw Exception('Brand cannot be empty');
    }
    if (stock.quantity < 0) {
      throw Exception('Stock quantity cannot be negative');
    }
    if (stock.expirationDate != null &&
        stock.expirationDate!.isBefore(DateTime.now())) {
      throw Exception('Expiration date cannot be in the past');
    }

    return await _repository.updateStock(inventoryId, productId, stock);
  }
}
