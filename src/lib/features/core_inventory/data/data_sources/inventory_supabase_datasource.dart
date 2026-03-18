import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/inventory.dart';
import '../models/stock.dart';

// Data source class handles all direct communication with Supabase
// Only place where Supabase is imported and used
// Responsibilities:
// execute raw database queries, convert Supabase responses to Models, 
// handle database-specific errors and return Models to repository

// Custom exceptions for data source
class DataSourceException implements Exception {
  final String message;
  DataSourceException(this.message);
}

class InventorySupabaseDataSource {
  final SupabaseClient _supabaseClient;
  
  InventorySupabaseDataSource(this._supabaseClient);
  
  // ========== INVENTORY METHODS ==========
  
  //Fetches an inventory by owner ID with all its stock data
  Future<InventoryModel> fetchInventoryByOwnerId(int ownerId) async {
    try {
      final response = await _supabaseClient
          .from('inventories')
          .select()
          .eq('ownerId', ownerId)
          .maybeSingle();
      
      if (response == null) {
        throw DataSourceException('Inventory not found for owner $ownerId');
      }
      
      return InventoryModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw DataSourceException('Supabase error: ${e.message}');
    } catch (e) {
      throw DataSourceException('Unexpected error: $e');
    }
  }
  
  //Creates a new inventory for an owner
  Future<InventoryModel> createInventory(InventoryModel inventory) async {
    try {
      final response = await _supabaseClient
          .from('inventories')
          .insert({
            'ownerId': inventory.ownerId,
            'stock': {}, //Initialize empty stock map
          })
          .select()
          .single();
    



      return InventoryModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to create inventory: ${e.message}');
    }
  }
  
  //Updates an entire inventory (including stock)
  Future<InventoryModel> updateInventory(InventoryModel inventory) async {
    try {
      final response = await _supabaseClient
          .from('inventories')
          .update(inventory.toJson())
          .eq('id', inventory.id)
          .select()
          .single();
      
      return InventoryModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to update inventory: ${e.message}');
    }
  }
  
  // ========== STOCK METHODS (All operations go through inventory) ==========
  
  //Adds stock to a specific product within an inventory
  Future<InventoryModel> addStockToInventory(
    int inventoryId, 
    int productId, 
    StockModel newStock
  ) async {
    try {
      //1. Fetching the current inventory
      final response = await _supabaseClient
          .from('inventories')
          .select()
          .eq('id', inventoryId)
          .maybeSingle();
      
      if (response == null) {
        throw DataSourceException('Inventory with ID $inventoryId not found');
      }
      
      //2. Parsing to InventoryModel
      final inventory = InventoryModel.fromJson(response);
      
      //3. Updating the stock map
      final updatedStockMap = Map<String, List<StockModel>>.from(inventory.stock);
      final productIdStr = productId.toString();
      
      if (updatedStockMap.containsKey(productIdStr)) {
        //Add to existing list
        updatedStockMap[productIdStr] = [...updatedStockMap[productIdStr]!, newStock];
      } else {
        
        //Create new list for this product
        updatedStockMap[productIdStr] = [newStock];
      }
      
      //4. Converting stock map to JSON format for Supabase
      final stockJson = updatedStockMap.map(
        (key, value) => MapEntry(
          key, 
          value.map((stock) => stock.toJson()).toList()
        ),
      );
      
      //5. Updating only the stock portion of the inventory
      final updateResponse = await _supabaseClient
          .from('inventories')
          .update({'stock': stockJson})
          .eq('id', inventoryId)
          .select()
          .single();
      
      return InventoryModel.fromJson(updateResponse);
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to add stock: ${e.message}');
    } catch (e) {
      throw DataSourceException('Unexpected error adding stock: $e');
    }
  }
  
  //Updating existing stock for a specific product within an inventory
  Future<InventoryModel> updateStockInInventory(
    int inventoryId, 
    int productId, 
    StockModel updatedStock
  ) async {
    try {
      //1. Fetching the current inventory
      final response = await _supabaseClient
          .from('inventories')
          .select()
          .eq('id', inventoryId)
          .maybeSingle();
      
      if (response == null) {
        throw DataSourceException('Inventory with ID $inventoryId not found');
      }
      
      //2. Parsing to InventoryModel
      final inventory = InventoryModel.fromJson(response);
      
      //3. Updating the specific stock in the map
      final updatedStockMap = Map<String, List<StockModel>>.from(inventory.stock);
      final productIdStr = productId.toString();
      
      if (updatedStockMap.containsKey(productIdStr)) {
        updatedStockMap[productIdStr] = updatedStockMap[productIdStr]!
            .map((stock) => stock.id == updatedStock.id ? updatedStock : stock)
            .toList();
      } else {
        throw DataSourceException('Product $productId not found in inventory');
      }
      
      //4. Converting stock map to JSON format for Supabase
      final stockJson = updatedStockMap.map(
        (key, value) => MapEntry(
          key, 
          value.map((stock) => stock.toJson()).toList()
        ),
      );
      
      //5. Updating only the stock portion of the inventory
      final updateResponse = await _supabaseClient
          .from('inventories')
          .update({'stock': stockJson})
          .eq('id', inventoryId)
          .select()
          .single();
      
      return InventoryModel.fromJson(updateResponse);
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to update stock: ${e.message}');
    } catch (e) {
      throw DataSourceException('Unexpected error updating stock: $e');
    }
  }
  
  //Deleting stock from a specific product within an inventory
  Future<InventoryModel> deleteStockFromInventory(
    int inventoryId, 
    int productId, 
    int stockId
  ) async {
    try {
      //1. Fetching the current inventory
      final response = await _supabaseClient
          .from('inventories')
          .select()
          .eq('id', inventoryId)
          .maybeSingle();
      
      if (response == null) {
        throw DataSourceException('Inventory with ID $inventoryId not found');
      }
      
      //2. Parsing to InventoryModel
      final inventory = InventoryModel.fromJson(response);
      
      //3. Removing the specific stock from the map
      final updatedStockMap = Map<String, List<StockModel>>.from(inventory.stock);
      final productIdStr = productId.toString();
      
      if (updatedStockMap.containsKey(productIdStr)) {
        updatedStockMap[productIdStr] = updatedStockMap[productIdStr]!
            .where((stock) => stock.id != stockId)
            .toList();
      }
      
      //4. Converting stock map to JSON format for Supabase
      final stockJson = updatedStockMap.map(
        (key, value) => MapEntry(
          key, 
          value.map((stock) => stock.toJson()).toList()
        ),
      );
      
      //5. Updating only the stock portion of the inventory
      final updateResponse = await _supabaseClient
          .from('inventories')
          .update({'stock': stockJson})
          .eq('id', inventoryId)
          .select()
          .single();
      
      return InventoryModel.fromJson(updateResponse);
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to delete stock: ${e.message}');
    } catch (e) {
      throw DataSourceException('Unexpected error deleting stock: $e');
    }
  }
  
  //Getting all stock for a specific product within an inventory
  Future<List<StockModel>> getStockForProduct(int inventoryId, int productId) async {
    try {
      final response = await _supabaseClient
          .from('inventories')
          .select()
          .eq('id', inventoryId)
          .maybeSingle();
      
      if (response == null) {
        throw DataSourceException('Inventory with ID $inventoryId not found');
      }
      
      final inventory = InventoryModel.fromJson(response);
      final productIdStr = productId.toString();
      
      return inventory.stock[productIdStr] ?? [];
    } on PostgrestException catch (e) {
      throw DataSourceException('Failed to fetch stock: ${e.message}');
    } catch (e) {
      throw DataSourceException('Unexpected error fetching stock: $e');
    }
  }
}
