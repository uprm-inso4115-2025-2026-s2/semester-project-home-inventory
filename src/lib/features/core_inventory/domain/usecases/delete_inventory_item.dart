import '../repositories/inventory_repositories.dart';

//use case to delete an inventory item (stock)

class DeleteInventoryItem {
  final InventoryRepository _repository;

  DeleteInventoryItem(this._repository);
  
  //[inventoryId] is the ID of the inventory
  //[productId] is the ID of the product containing the stock
  //[stockId] is the ID of the stock to delete

  Future<void> call(int inventoryId, int productId, int stockId) async {
    
    //validations

    if (inventoryId <= 0) {
      throw Exception('Inventory ID must be a positive number');
    }

    if (productId <= 0) {
      throw Exception('Product ID must be a positive number');
    }

    if (stockId <= 0) {
      throw Exception('Stock ID must be a positive number');
    }

    await _repository.deleteStock(inventoryId, productId, stockId);
  }
}
