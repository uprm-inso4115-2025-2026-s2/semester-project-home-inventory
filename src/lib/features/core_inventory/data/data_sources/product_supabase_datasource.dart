import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import '../../../core_inventory/data/data_sources/inventory_supabase_datasource.dart';

class ProductSupabaseDataSource {
  final SupabaseClient _supabaseClient;
  
  ProductSupabaseDataSource(this._supabaseClient);
  
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

  Future<ProductModel?> fetchProductById(int productId) async {
    try {
      final response = await _supabaseClient
          .from('products')
          .select()
          .eq('id', productId)
          .maybeSingle();
      
      if (response == null) return null;
      
      return ProductModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw DataSourceException('Supabase error fetching product: ${e.message}');
    }
  }
}
