import '../entities/product.dart';
import '../entities/enums.dart';

//Repository for Product operations
//Products can exist independently of inventory
abstract class ProductRepository {
  //Adds a new product
Future<ProductEntity> addProduct(ProductEntity product);
  
  //Updates an existing product
  Future<ProductEntity> updateProduct(ProductEntity product);
  
  //Deletes a product by ID
  Future<void> deleteProduct(int productId);
  
  //Gets all products
  Future<List<ProductEntity>> getAllProducts();
  
  //Searches products by name and optional tags
  Future<List<ProductEntity>> searchProducts(String query, {List<Tag>? tags});
  
  //Gets a product by ID
  Future<ProductEntity?> getProductById(int productId);
}
