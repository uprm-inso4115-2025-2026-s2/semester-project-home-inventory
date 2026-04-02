import 'package:src/features/core_inventory/domain/repositories/product_repository.dart';
import '../../domain/repositories/inventory_repositories.dart'; 
import '../../domain/entities/inventory.dart';                  
import '../../domain/entities/product.dart';                
import '../../domain/entities/stock.dart';                    
import '../../domain/entities/enums.dart';                    
import '../data_sources/inventory_supabase_datasource.dart';    
import '../models/inventory.dart';                              
import '../models/stock.dart';     

//Implements the domain repository contract and bridges the domain layer with the data layer
//Responsabilities:
//validate business rules before database operations
//Convert Entities
//Convert Models
//Handling and translating errors to exceptions 
//NO direct database knowledge

// Simple custom exceptions
class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);
}

class InventoryRepositoryImpl implements InventoryRepository {
  final InventorySupabaseDataSource _dataSource;
  final ProductRepository _productRepository;
  
  InventoryRepositoryImpl(this._dataSource, this._productRepository);
  
@override
Future<InventoryEntity> getInventoryByOwnerId(int ownerId) async {
  if(ownerId <= 0){
    throw RepositoryException('Invalid owner ID');
  }

  try {
    final inventoryModel = await _dataSource.fetchInventoryByOwnerId(ownerId);
    
    // Convert to entity
    final stockEntities = <ProductEntity, List<StockEntity>>{};
    
    for (final entry in inventoryModel.stock.entries) {

      final productId = int.parse(entry.key);    //
      final productEntity = await _productRepository.getProductById(productId);

      if(productEntity == null){
        throw RepositoryException('Product with ID $productId not found');
      }
      
      stockEntities[productEntity] = entry.value
          .map((model) => model.toEntity())
          .toList();
    }
    
    return inventoryModel.toEntity(stockEntities);
  } catch (e) {
    throw RepositoryException('Failed to get inventory: $e');
  }
}
  
  @override
  Future<InventoryEntity> createInventory(InventoryEntity inventory) async {
    
    //Validation
    if(inventory.ownerId <= 0){
      throw RepositoryException('Invalid owner ID');
    }

    try {
      final inventoryModel= InventoryModel.fromEntity(inventory);
      final createdModel = await _dataSource.createInventory(inventoryModel);
      return createdModel.toEntity({});
    } catch (e) {
      throw RepositoryException('Failed to create inventory: $e');
    }
  }
  
  @override
  Future<InventoryEntity> updateInventory(InventoryEntity inventory) async {

    //Validation
    if(inventory.id <= 0){
      throw RepositoryException('Invalid inventory ID');
    }

    if(inventory.ownerId <= 0){
      throw RepositoryException('Invalid owner Id');
    }

    try {
      final inventoryModel= InventoryModel.fromEntity(inventory);

      final updateModel= await _dataSource.updateInventory(inventoryModel);
      return updateModel.toEntity(inventory.stock);

    } catch (e) {
      throw RepositoryException('Failed to update inventory: $e');
    }
  }
  
  
  @override
  Future<StockEntity> addStock(int inventoryId, int productId, StockEntity stock) async {
    
    //Validation
    if(inventoryId <= 0){
      throw RepositoryException('Invalid inventory ID');
    }

    if(productId <= 0){
      throw RepositoryException('Invalid product ID');
    }

    if(stock.brand.isEmpty){
      throw RepositoryException('Brand cannot be empty');
    }

    if(stock.quantity <= 0){
      throw RepositoryException('Stock quantity cannot be zero or negative');
    }
    
    //validating expiration date if provided 
    if(stock.expirationDate != null){
      if(stock.expirationDate!.isBefore(DateTime.now())){
        throw RepositoryException('Expiration date cannot be in the past');
      }
    }

    if(stock.status == Status.EXPIRED){
      throw RepositoryException('Cannot add stock with expired status');
    }


    try {
      final stockModel = StockModel.fromEntity(stock);
      final updatedInventory = await _dataSource.addStockToInventory(
        inventoryId,
        productId,
        stockModel,
      );
      final productStock = updatedInventory.stock[productId.toString()];
      if (productStock == null || productStock.isEmpty) {
        throw RepositoryException('Failed to add stock for product $productId');
      }
      return productStock.last.toEntity();
    } catch (e) {
      throw RepositoryException('Failed to add stock: $e');
    }
  }
  
  @override
  Future<StockEntity> updateStock(int inventoryId, int productId, StockEntity stock) async {
    
    //Validation
    if(inventoryId <= 0){
      throw RepositoryException('Invalid inventory ID');
    }

    if(productId <= 0){
      throw RepositoryException('Invalid product ID');    
    }

    if(stock.brand.isEmpty){
      throw RepositoryException('Brand cannot be empty');
    }

    if(stock.quantity <= 0){
      throw RepositoryException('Stock quantity cannot be zero or negative');
    }
    
    //validating expiration date if provided 
    if(stock.expirationDate != null){
      if(stock.expirationDate!.isBefore(DateTime.now())){
        throw RepositoryException('Expiration date cannot be in the past');
      }
    }


   try {
      final stockModel = StockModel.fromEntity(stock);
      final updatedInventory = await _dataSource.updateStockInInventory(
        inventoryId,
        productId,
        stockModel,
      );
      final productStock = updatedInventory.stock[productId.toString()];
      if (productStock == null || productStock.isEmpty) {
        throw RepositoryException('Product $productId not found in inventory');
      }

      final updatedStock = productStock
          .cast<StockModel>()
          .firstWhere((s) => s.id == stock.id, orElse: () => StockModel.initial());

      if (updatedStock.id == -1) {
        throw RepositoryException('Stock ${stock.id} was not found after update');
      }

      return updatedStock.toEntity();
    } catch (e) {
      throw RepositoryException('Failed to update stock: $e');
    }
  }
  
  @override
  Future<void> deleteStock(int inventoryId, int productId, int stockId) async {
    
    //Validation
    if(inventoryId <= 0){
      throw RepositoryException('Invalid inventory ID');
    }
  
    if(productId <= 0){
      throw RepositoryException('Invalid product ID');
    }

    if(stockId <= 0){
      throw RepositoryException('Invalid stock ID');
    }

    try {
      await _dataSource.deleteStockFromInventory(inventoryId, productId, stockId);
    } catch (e) {
      throw RepositoryException('Failed to delete stock: $e');
    }
  }
  
  @override
  Future<List<StockEntity>> getStockForProduct(int inventoryId, int productId) async {
    
    //Validation
    if(inventoryId <= 0){
      throw RepositoryException('Invalid inventory ID');
    }

    if(productId <= 0){
      throw RepositoryException('Invalid product ID');
    }

    try {
      final stockModels = await _dataSource.getStockForProduct(inventoryId, productId);
      return stockModels
          .map((model) => model.toEntity())
          .toList();
    } catch (e) {
      throw RepositoryException('Failed to get stock for product: $e');
    }
  }


}
