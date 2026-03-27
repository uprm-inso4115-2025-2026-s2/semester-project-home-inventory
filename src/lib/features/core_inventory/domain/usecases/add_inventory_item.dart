import '../entities/stock.dart';
import '../repositories/inventory_repositories.dart';
import '../entities/enums.dart';

//use case to add a new inventory item (stock) to a product

class AddInventoryItem{
  final InventoryRepository _repository;

  AddInventoryItem(this._repository);

  //[inventoryId] is the ID of the inventory
  //[productId] is the ID of the product to add stock to 
  //[stock] the stock entity to add
  //returns [StockEntity] with the created stock

  Future<StockEntity> call(int inventoryId, int productId, StockEntity stock) async {

    //validation

    if(inventoryId <= 0){
      throw Exception("Inventory ID must be a positive number");
    }

    if(productId <= 0){
      throw Exception("Product ID must be a positive number");
    }

    if(stock.brand.isEmpty){
      throw Exception("Brand cannot be empty");
    }

    if(stock.quantity <= 0){
      throw Exception("Stock quantity must be greater than zero");
    }

    if(stock.expirationDate != null && stock.expirationDate!.isBefore(DateTime.now())){
      throw Exception("Expiration date cannot be in the past");
    }

    if(stock.status == Status.EXPIRED){
      throw Exception("Cannot add stock with expired status");
    }

    return await _repository.addStock(inventoryId, productId, stock);
  }
}
