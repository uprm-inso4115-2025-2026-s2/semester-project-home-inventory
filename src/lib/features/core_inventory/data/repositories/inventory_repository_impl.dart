import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/inventory_repositories.dart'; 
import '../../domain/entities/inventory.dart';                  
import '../../domain/entities/product.dart';                
import '../../domain/entities/stock.dart';                    
import '../../domain/entities/enums.dart';                    
import '../data_sources/inventory_supabase_datasource.dart';    
import '../models/inventory.dart';                              
import '../models/product.dart';                          
import '../models/stock.dart';     
import '/core/util/util.dart';

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
  
  InventoryRepositoryImpl(this._dataSource);
  
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

      final productId = int.parse(entry.key);
      final productModel = await _dataSource.fetchProductById(productId);  // Using fetch product by id from data source file
      final productEntity = productModel.toEntity() as ProductEntity;
      
      stockEntities[productEntity] = entry.value
          .map((model) => model.toEntity() as StockEntity)
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
  Future<ProductEntity> addProduct(ProductEntity product) async {
    
    //Validation
    if(product.name.isEmpty){
      throw RepositoryException('Product name cannot be empty');
    }

    if(product.description.isEmpty){
      throw RepositoryException("Product description cannot be empty");
    }

    if(product.unit != null && product.unit!.isEmpty){
      throw RepositoryException('Unit cannot be empty if provided');
    }

    //Validating imageUrl format if needed
    if (product.imageUrl != null && !AppUtils.isValidUrl(product.imageUrl!)) {
      throw RepositoryException('Invalid image URL format');
    }

    try {
      final productModel = ProductModel.fromEntity(product as ProductModel);
      final createdModel = await _dataSource.insertProduct(productModel);
      return createdModel.toEntity() as ProductEntity;
    } catch (e) {
      throw RepositoryException('Failed to add product: $e');
    }
  }
  
  @override
  Future<ProductEntity> updateProduct(ProductEntity product) async {
    
    //Validation
    if(product.name.isEmpty){
      throw RepositoryException('Product name cannot be empty');
    }

    if(product.description.isEmpty){
      throw RepositoryException("Product description cannot be empty");
    }


    if(product.unit != null && product.unit!.isEmpty){
      throw RepositoryException('Unit cannot be empty if provided');
    }

    //Validating imageUrl format if needed
    if (product.imageUrl != null && !AppUtils.isValidUrl(product.imageUrl!)) {
      throw RepositoryException('Invalid image URL format');
    }

    try {
      final productModel = ProductModel.fromEntity(product as ProductModel);
      final updatedModel = await _dataSource.updateProduct(productModel);
      return updatedModel.toEntity() as ProductEntity;
    } catch (e) {
      throw RepositoryException('Failed to update product: $e');
    }
  }
  
  @override
  Future<void> deleteProduct(int productId) async {
    
    //Validation
    if(productId <= 0){
      throw RepositoryException('Invalid product ID');
    }

    try {
      await _dataSource.deleteProduct(productId);
    } catch (e) {
      throw RepositoryException('Failed to delete product: $e');
    }
  }
  
  @override
  Future<List<ProductEntity>> getAllProducts() async {
    try {
      final productModels = await _dataSource.fetchAllProducts();
      return productModels
          .map((model) => model.toEntity() as ProductEntity)
          .toList();
    } catch (e) {
      throw RepositoryException('Failed to get all products: $e');
    }
  }
  
  @override
  Future<List<ProductEntity>> searchProducts(String query, {List<Tag>? tags}) async {
    try {
      final tagNames = tags?.map((tag) => tag.name).toList();
      final productModels = await _dataSource.searchProducts(query, tags: tagNames);
      return productModels
          .map((model) => model.toEntity() as ProductEntity)
          .toList();
    } catch (e) {
      throw RepositoryException('Failed to search products: $e');
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
      final stockModel = StockModel.fromEntity(stock as StockModel);
      final createdModel = await _dataSource.insertStock(stockModel);
      return createdModel.toEntity() as StockEntity;
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
      final stockModel = StockModel.fromEntity(stock as StockModel);
      final updatedModel = await _dataSource.updateStock(stockModel);
      return updatedModel.toEntity() as StockEntity;
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
      await _dataSource.deleteStock(stockId);
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
      final stockModels = await _dataSource.fetchStockForProduct(productId);
      return stockModels
          .map((model) => model.toEntity() as StockEntity)
          .toList();
    } catch (e) {
      throw RepositoryException('Failed to get stock for product: $e');
    }
  }


}
