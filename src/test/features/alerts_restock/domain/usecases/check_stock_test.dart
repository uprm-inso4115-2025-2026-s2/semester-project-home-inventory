import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/alerts_restock/domain/entities/stock_status.dart';
import 'package:src/features/alerts_restock/domain/usecases/check_stock.dart';

void main(){
  // an item without stock value should default to in stock
  test('returns inStock when stock is null', (){
    final result = checkStock(currentStock: null);

    expect(result, StockStatus.inStock);
  });
  // negative stock values should be treated as invalid
  test('returns inStock when stock is invalid', (){
    final result = checkStock(currentStock: -1);

    expect(result, StockStatus.inStock);
  });
  // zero stock means the item is unavailable
  test('returns outOfStock when stock is zero', (){
    final result = checkStock(currentStock: 0);

    expect(result, StockStatus.outOfStock);
  });
  // quantities within the threshold should be low stock
  test('returns lowStock when stock is within threshold', (){
    final result = checkStock(
      currentStock: 3,
      threshold: 5,
    );
    expect(result, StockStatus.lowStock);
  });
  // quantities above the threshold should be in stock
  test('returns inStock when stock is above threshold', (){
    final result = checkStock(
      currentStock: 10,
      threshold: 5,
    );
    expect(result, StockStatus.inStock);
  });
}