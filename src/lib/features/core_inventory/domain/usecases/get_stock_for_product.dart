import '../entities/stock.dart';
import '../repositories/inventory_repositories.dart';

//use case to get all stock for a specific product in an inventory

class GetStockForProduct {
  final InventoryRepository _repository;

  GetStockForProduct(this._repository);

  //[inventoryId] is the ID of the inventory
  //[productId] is the ID of the product
  //returns [List<StockEntity>] containing all stock for the product

  Future<List<StockEntity>> call(int inventoryId, int productId) async {
    //validations

    if (inventoryId <= 0) {
      throw Exception('Inventory ID must be a positive number');
    }

    if (productId <= 0) {
      throw Exception('Product ID must be a positive number');
    }

    return await _repository.getStockForProduct(inventoryId, productId);
  }
}
