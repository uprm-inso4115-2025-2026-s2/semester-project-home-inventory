import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';
import 'package:src/features/core_inventory/presentation/cubits/product_stock_state.dart';
import 'package:src/features/core_inventory/presentation/mock_data/sample_data.dart';

class ProductStockCubit extends Cubit<ProductStockState> {
  ProductStockCubit() : super(ProductStockInitial());

  void loadProduct(int productId) {
    final inventory = buildSampleInventory();
    final product = inventory.stock.keys.firstWhere(
      (p) => p.id == productId,
      orElse: () => inventory.stock.keys.first,
    );
    final stocks = List<StockEntity>.from(inventory.stock[product] ?? []);
    emit(ProductStockLoaded(product: product, stocks: stocks));
  }

  void setFilter(String? filter) {
    final current = state;
    if (current is! ProductStockLoaded) return;
    emit(current.copyWith(activeFilter: filter, clearFilter: filter == null));
  }

  void toggleSortDirection() {
    final current = state;
    if (current is! ProductStockLoaded) return;
    emit(current.copyWith(sortAscending: !current.sortAscending));
  }

  void removeStock(int stockId) {
    final current = state;
    if (current is! ProductStockLoaded) return;
    final updated = current.stocks.where((s) => s.id != stockId).toList();
    emit(current.copyWith(stocks: updated));
  }
}