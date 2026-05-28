import '../../domain/entities/report_filters.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/entities/report_filter_validator.dart';

class CategoryData {
  final String name;
  final int quantity;
  const CategoryData(this.name, this.quantity);
}

class ItemData {
  final String name;     // item_name (or category_name if missing)
  final String category; // category_name
  final int quantity;    // items_used
  final String status;   // derived from usage_rate_percent
  const ItemData(this.name, this.category, this.quantity, this.status);
}

class InventoryStockReportState {
  final ReportFilters filters;
  final List<ItemData> allItems;
  final List<ReportFavorite> favorites;
  final ValidationResult? validationResult;
  final bool isLoadingFavorites;
  final String? favoriteError;
  final bool isLoading;
  final String? errorMessage;
  final String? warningMessage;

  const InventoryStockReportState({
    required this.filters,
    required this.allItems,
    this.favorites = const [],
    this.validationResult,
    this.isLoadingFavorites = false,
    this.favoriteError,
    this.isLoading = false,
    this.errorMessage,
    this.warningMessage,
  });

  // Filtered items by search query
  List<ItemData> get filteredItems {
    var items = allItems;
    if (filters.searchQuery.isNotEmpty) {
      final lower = filters.searchQuery.toLowerCase();
      items = items.where((i) =>
          i.name.toLowerCase().contains(lower) ||
          i.category.toLowerCase().contains(lower) ||
          i.status.toLowerCase().contains(lower)).toList();
    }
    return items;
  }

  // Aggregated by category for the bar chart
  List<CategoryData> get currentPageData {
    final Map<String, int> categoryTotals = {};
    for (final item in allItems) {
      categoryTotals[item.category] = (categoryTotals[item.category] ?? 0) + item.quantity;
    }
    return categoryTotals.entries
        .map((e) => CategoryData(e.key, e.value))
        .toList();
  }

  InventoryStockReportState copyWith({
    ReportFilters? filters,
    List<ItemData>? allItems,
    List<ReportFavorite>? favorites,
    ValidationResult? validationResult,
    bool? isLoadingFavorites,
    String? favoriteError,
    bool? isLoading,
    String? errorMessage,
    String? warningMessage,
  }) {
    return InventoryStockReportState(
      filters: filters ?? this.filters,
      allItems: allItems ?? this.allItems,
      favorites: favorites ?? this.favorites,
      validationResult: validationResult ?? this.validationResult,
      isLoadingFavorites: isLoadingFavorites ?? this.isLoadingFavorites,
      favoriteError: favoriteError ?? this.favoriteError,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      warningMessage: warningMessage ?? this.warningMessage,
    );
  }
}