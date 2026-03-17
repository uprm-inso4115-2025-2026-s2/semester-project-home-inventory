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
  
  
  // ========== STOCK METHODS ==========
  
  Future<StockModel> insertStock(int inventoryId, int productId, StockModel stock) async {
    try {

      final stockData= {
        ...stock.toJson(),
        'inventoryId': inventoryId,
        'productId': productId,
      };
      
      final response = await _supabaseClient
          .from('stock')
          .insert(stockData)
          .select()
          .single();
      
      return StockModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to insert stock: ${e.message}');
    }
  }
  
  Future<StockModel> updateStock(int inventoryId, int productId, StockModel stock) async {
    try {

      final stockData= {
        ...stock.toJson(),
        'inventoryId': inventoryId,
        'productId': productId,
      };

      final response = await _supabaseClient
          .from('stock')
          .update(stockData)
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
  
  Future<List<StockModel>> fetchStockForProduct(int inventoryId, int productId) async {
    try {
      final response = await _supabaseClient
          .from('stock')
          .select()
          .eq('inventoryId', inventoryId)
          .eq('productId', productId);
      
      return (response as List)
          .map((json) => StockModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to fetch stock: ${e.message}');
    }
  }
}
