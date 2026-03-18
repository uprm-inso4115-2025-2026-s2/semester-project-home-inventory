import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/enums.dart';
import '../data_sources/product_supabase_datasource.dart';
import '../models/product.dart';
import '/core/util/util.dart';
import '../../../core_inventory/data/repositories/inventory_repository_impl.dart';


class ProductRepositoryImpl implements ProductRepository {
  final ProductSupabaseDataSource _dataSource;
  
  ProductRepositoryImpl(this._dataSource);
  
  @override
  Future<ProductEntity> addProduct(ProductEntity product) async {
    // Validation
    if(product.name.isEmpty){
      throw RepositoryException('Product name cannot be empty');
    }
    if(product.description.isEmpty){
      throw RepositoryException("Product description cannot be empty");
    }
    if(product.unit != null && product.unit!.isEmpty){
      throw RepositoryException('Unit cannot be empty if provided');
    }
    if (product.imageUrl != null && !AppUtils.isValidUrl(product.imageUrl!)) {
      throw RepositoryException('Invalid image URL format');
    }

    try {
      final productModel = ProductModel.fromEntity(product);
      final createdModel = await _dataSource.insertProduct(productModel);
      return createdModel.toEntity();
    } catch (e) {
      throw RepositoryException('Failed to add product: $e');
    }
  }
  
  @override
  Future<ProductEntity> updateProduct(ProductEntity product) async {
    // Validation
    if(product.name.isEmpty){
      throw RepositoryException('Product name cannot be empty');
    }
    if(product.description.isEmpty){
      throw RepositoryException("Product description cannot be empty");
    }
    if(product.unit != null && product.unit!.isEmpty){
      throw RepositoryException('Unit cannot be empty if provided');
    }
    if (product.imageUrl != null && !AppUtils.isValidUrl(product.imageUrl!)) {
      throw RepositoryException('Invalid image URL format');
    }

    try {
      final productModel = ProductModel.fromEntity(product);
      final updatedModel = await _dataSource.updateProduct(productModel);
      return updatedModel.toEntity();
    } catch (e) {
      throw RepositoryException('Failed to update product: $e');
    }
  }
  
  @override
  Future<void> deleteProduct(int productId) async {
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
          .map((model) => model.toEntity())
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
          .map((model) => model.toEntity())
          .toList();
    } catch (e) {
      throw RepositoryException('Failed to search products: $e');
    }
  }
  
  @override
  Future<ProductEntity?> getProductById(int productId) async {
    try {
      final productModel = await _dataSource.fetchProductById(productId);
      return productModel?.toEntity();
    } catch (e) {
      throw RepositoryException('Failed to get product: $e');
    }
  }
}
