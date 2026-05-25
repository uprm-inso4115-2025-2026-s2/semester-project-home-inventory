import 'package:src/features/core_inventory/domain/entities/product.dart';
import 'package:src/features/core_inventory/domain/entities/enums.dart';
import 'package:src/features/core_inventory/domain/repositories/product_repository.dart';

/// A fake implementation of ProductRepository for testing.
class FakeProductRepository implements ProductRepository {
  final Map<int, ProductEntity> _products = {};
  int _nextProductId = 1;

  FakeProductRepository({Map<int, ProductEntity>? initialProducts}) {
    if (initialProducts != null) {
      _products.addAll(initialProducts);
      _nextProductId = (initialProducts.keys.isEmpty ? 1 : initialProducts.keys.reduce((a, b) => a > b ? a : b)) + 1;
    }
  }

  @override
  Future<ProductEntity> addProduct(ProductEntity product) async {
    final newProduct = ProductEntity(
      id: _nextProductId++,
      name: product.name,
      description: product.description,
      unit: product.unit,
      imageUrl: product.imageUrl,
    );
    _products[newProduct.id] = newProduct;
    return newProduct;
  }

  @override
  Future<ProductEntity> updateProduct(ProductEntity product) async {
    if (!_products.containsKey(product.id)) {
      throw Exception('Product not found');
    }
    _products[product.id] = product;
    return product;
  }

  @override
  Future<void> deleteProduct(int productId) async {
    if (!_products.containsKey(productId)) {
      throw Exception('Product not found');
    }
    _products.remove(productId);
  }

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    return _products.values.toList();
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query, {List<Tag>? tags}) async {
    return _products.values
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<ProductEntity?> getProductById(int productId) async {
    return _products[productId];
  }

  void clear() => _products.clear();
}
