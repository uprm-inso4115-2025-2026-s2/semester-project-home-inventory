import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/inventory.dart';
import '../models/product.dart';
import '../models/stock.dart';


//Data source class handles all direct communication with Supabase
//Only place where Supabase is imported and used!
//Responsabilities:
//execute raw database queries, convert Supabase responses to Models, handle database-specific errors and return Models to repository

// Custom exceptions for data source
class DataSourceException implements Exception {
  final String message;
  DataSourceException(this.message);
}

class InventorySupabaseDataSource {
  final SupabaseClient _supabaseClient;
  
  InventorySupabaseDataSource(this._supabaseClient);
  
  // ========== INVENTORY METHODS ==========
  
  Future<InventoryModel> fetchInventoryByOwnerId(int ownerId) async {
    try {
      // Fetch the inventory
      final inventoryResponse = await _supabaseClient
          .from('inventories')
          .select()
          .eq('ownerId', ownerId)
          .maybeSingle();
      
      if (inventoryResponse == null) {
        throw DataSourceException('Inventory not found for owner $ownerId');
      }
      
      // Fetch all products for this inventory
      final productsResponse = await _supabaseClient
          .from('products')
          .select()
          .eq('inventoryId', inventoryResponse['id']);
      
      // Fetch stock for each product
      final stockMap = <String, List<StockModel>>{};
      
      for (final product in productsResponse) {
        final productId = product['id'].toString();
        final stockResponse = await _supabaseClient
            .from('stock')
            .select()
            .eq('productId', product['id']);
        
        stockMap[productId] = (stockResponse as List)
            .map((json) => StockModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      
      return InventoryModel(
        id: inventoryResponse['id'] as int,
        ownerId: inventoryResponse['ownerId'] as int,
        stock: stockMap,
      );
    } on PostgrestException catch (e) {
      throw DataSourceException('Supabase error: ${e.message}');
    } catch (e) {
      throw DataSourceException('Unexpected error: $e');
    }
  }
  
  Future<InventoryModel> createInventory(InventoryModel inventory) async {
    try {
      final response = await _supabaseClient
          .from('inventories')
          .insert({'ownerId': inventory.ownerId})
          .select()
          .single();
      
      return InventoryModel(
        id: response['id'] as int,
        ownerId: response['ownerId'] as int,
        stock: {},
      );
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to create inventory: ${e.message}');
    }
  }
  
  Future<InventoryModel> updateInventory(InventoryModel inventory) async {
    try {
      await _supabaseClient
          .from('inventories')
          .update({'ownerId': inventory.ownerId})
          .eq('id', inventory.id);
      
      return inventory; // Return the updated model
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to update inventory: ${e.message}');
    }
  }
  
  // ========== PRODUCT METHODS ==========
  
  Future<ProductModel> insertProduct(ProductModel product) async {
    try {
      final response = await _supabaseClient
          .from('products')
          .insert(product.toJson())
          .select()
          .single();
      
      return ProductModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to insert product: ${e.message}');
    }
  }
  
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      final response = await _supabaseClient
          .from('products')
          .update(product.toJson())
          .eq('id', product.id)
          .select()
          .single();
      
      return ProductModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to update product: ${e.message}');
    }
  }
  
  Future<void> deleteProduct(int productId) async {
    try {
      await _supabaseClient
          .from('products')
          .delete()
          .eq('id', productId);
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to delete product: ${e.message}');
    }
  }
  
  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final response = await _supabaseClient
          .from('products')
          .select();
      
      return (response as List)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to fetch products: ${e.message}');
    }
  }
  
  Future<List<ProductModel>> searchProducts(String query, {List<String>? tags}) async {
    try {
      var searchQuery = _supabaseClient
          .from('products')
          .select()
          .ilike('name', '%$query%');
      
      if (tags != null && tags.isNotEmpty) {
        // This assumes tags are stored as an array in Supabase
        searchQuery = searchQuery.contains('tags', tags);
      }
      
      final response = await searchQuery;
      
      return (response as List)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to search products: ${e.message}');
    }
  }

  Future<ProductModel> fetchProductById(int productId) async {
  try {
    final response = await _supabaseClient
        .from('products')
        .select()
        .eq('id', productId)
        .maybeSingle();
    
    if (response == null) {
      throw DataSourceException('Product with ID $productId not found');
    }
    
    return ProductModel.fromJson(response);
  } on PostgrestException catch (e) {
    throw DataSourceException('Supabase error fetching product: ${e.message}');
  } catch (e) {
    throw DataSourceException('Unexpected error fetching product: $e');
  }
}
  
  // ========== STOCK METHODS ==========
  
  Future<StockModel> insertStock(StockModel stock) async {
    try {
      final response = await _supabaseClient
          .from('stock')
          .insert(stock.toJson())
          .select()
          .single();
      
      return StockModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to insert stock: ${e.message}');
    }
  }
  
  Future<StockModel> updateStock(StockModel stock) async {
    try {
      final response = await _supabaseClient
          .from('stock')
          .update(stock.toJson())
          .eq('id', stock.id)
          .select()
          .single();
      
      return StockModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to update stock: ${e.message}');
    }
  }
  
  Future<void> deleteStock(int stockId) async {
    try {
      await _supabaseClient
          .from('stock')
          .delete()
          .eq('id', stockId);
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to delete stock: ${e.message}');
    }
  }
  
  Future<List<StockModel>> fetchStockForProduct(int productId) async {
    try {
      final response = await _supabaseClient
          .from('stock')
          .select()
          .eq('productId', productId);
      
      return (response as List)
          .map((json) => StockModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to fetch stock: ${e.message}');
    }
  }
}
