import 'package:src/features/core_inventory/domain/entities/product.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';

class EditItemState {
  final ProductEntity product;
  final StockEntity stock;

  const EditItemState({required this.product, required this.stock});
}
