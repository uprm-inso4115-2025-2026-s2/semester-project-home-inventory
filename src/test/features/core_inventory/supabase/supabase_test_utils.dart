import 'package:supabase_flutter/supabase_flutter.dart';

/// Test utilities for Supabase integration testing.
/// Provides helpers for creating test data and cleanup.
class SupabaseTestUtils {
  final SupabaseClient supabaseClient;
  final List<String> _createdUserIds = [];
  final List<int> _createdInventoryIds = [];
  final List<int> _createdProductIds = [];

  SupabaseTestUtils(this.supabaseClient);

  /// Creates a test user via Supabase Auth.
  /// Returns the user ID.
  Future<String> createTestUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Failed to create test user');
      }

      _createdUserIds.add(response.user!.id);
      return response.user!.id;
    } catch (e) {
      throw Exception('Error creating test user: $e');
    }
  }

  /// Creates a test inventory in the database.
  Future<int> createTestInventory({
    required int ownerId,
    Map<String, dynamic>? stock,
  }) async {
    try {
      final response = await supabaseClient
          .from('inventories')
          .insert({
            'ownerId': ownerId,
            'stock': stock ?? {},
          })
          .select()
          .single();

      final id = response['id'] as int;
      _createdInventoryIds.add(id);
      return id;
    } catch (e) {
      throw Exception('Error creating test inventory: $e');
    }
  }

  /// Creates a test product in the database.
  Future<int> createTestProduct({
    required String name,
    String? description,
    String? unit,
    String? imageUrl,
  }) async {
    try {
      final response = await supabaseClient
          .from('products')
          .insert({
            'name': name,
            'description': description ?? '',
            'unit': unit ?? 'units',
            'imageUrl': imageUrl,
          })
          .select()
          .single();

      final id = response['id'] as int;
      _createdProductIds.add(id);
      return id;
    } catch (e) {
      throw Exception('Error creating test product: $e');
    }
  }

  /// Adds stock to an inventory.
  Future<void> addStockToInventory({
    required int inventoryId,
    required int productId,
    required String brand,
    required int quantity,
    DateTime? expirationDate,
  }) async {
    try {
      // Fetch current inventory
      final response = await supabaseClient
          .from('inventories')
          .select()
          .eq('id', inventoryId)
          .maybeSingle();

      if (response == null) {
        throw Exception('Inventory not found');
      }

      final stock = response['stock'] as Map<String, dynamic>? ?? {};
      final productIdStr = productId.toString();

      final newStock = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'brand': brand,
        'quantity': quantity,
        'status': 'IN_STOCK',
        'expirationDate': expirationDate?.toIso8601String(),
      };

      if (stock.containsKey(productIdStr)) {
        stock[productIdStr] = [...(stock[productIdStr] as List), newStock];
      } else {
        stock[productIdStr] = [newStock];
      }

      await supabaseClient
          .from('inventories')
          .update({'stock': stock})
          .eq('id', inventoryId);
    } catch (e) {
      throw Exception('Error adding stock: $e');
    }
  }

  /// Cleans up all created test data.
  /// Call this in tearDown to ensure no orphaned data remains.
  Future<void> cleanup() async {
    try {
      // Delete inventories
      for (final id in _createdInventoryIds) {
        try {
          await supabaseClient.from('inventories').delete().eq('id', id);
        } catch (_) {
          // Ignore errors during cleanup
        }
      }

      // Delete products
      for (final id in _createdProductIds) {
        try {
          await supabaseClient.from('products').delete().eq('id', id);
        } catch (_) {
          // Ignore errors during cleanup
        }
      }

      // Delete users (requires admin access, may fail)
      for (final id in _createdUserIds) {
        try {
          // Users are deleted via Auth, not the table
          // In a real scenario, you'd need to use service role for this
          // For now, we just log that we tried
          print('Test user $id would need admin deletion');
        } catch (_) {
          // Ignore errors during cleanup
        }
      }

      _createdUserIds.clear();
      _createdInventoryIds.clear();
      _createdProductIds.clear();
    } catch (e) {
      print('Error during cleanup: $e');
    }
  }

  /// Resets the tracking lists without deleting from database.
  /// Useful if cleanup has already been done elsewhere.
  void resetTracking() {
    _createdUserIds.clear();
    _createdInventoryIds.clear();
    _createdProductIds.clear();
  }
}
