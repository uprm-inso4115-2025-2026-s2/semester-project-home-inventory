import 'package:equatable/equatable.dart';
import 'package:src/features/core_inventory/domain/entities/product.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';

abstract class ProductStockState extends Equatable {
  const ProductStockState();

  @override
  List<Object?> get props => [];
}

class ProductStockInitial extends ProductStockState {}

class ProductStockLoading extends ProductStockState {}

class ProductStockLoaded extends ProductStockState {
  final ProductEntity product;
  final List<StockEntity> stocks;
  final String? activeFilter;
  final bool sortAscending;

  const ProductStockLoaded({
    required this.product,
    required this.stocks,
    this.activeFilter,
    this.sortAscending = true,
  });

  int get totalQuantity => stocks.fold(0, (sum, s) => sum + s.quantity);

  DateTime? get earliestExpiration {
    DateTime? earliest;
    for (final s in stocks) {
      if (s.expirationDate == null) continue;
      if (earliest == null || s.expirationDate!.isBefore(earliest)) {
        earliest = s.expirationDate;
      }
    }
    return earliest;
  }

  List<StockEntity> get displayedStocks {
    if (activeFilter != 'expiration') return stocks;
    final sorted = List<StockEntity>.from(stocks);
    sorted.sort((a, b) {
      final aDate = a.expirationDate;
      final bDate = b.expirationDate;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return sortAscending ? aDate.compareTo(bDate) : bDate.compareTo(aDate);
    });
    return sorted;
  }

  ProductStockLoaded copyWith({
    ProductEntity? product,
    List<StockEntity>? stocks,
    String? activeFilter,
    bool? sortAscending,
    bool clearFilter = false,
  }) {
    return ProductStockLoaded(
      product: product ?? this.product,
      stocks: stocks ?? this.stocks,
      activeFilter: clearFilter ? null : (activeFilter ?? this.activeFilter),
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  @override
  List<Object?> get props => [product, stocks, activeFilter, sortAscending];
}