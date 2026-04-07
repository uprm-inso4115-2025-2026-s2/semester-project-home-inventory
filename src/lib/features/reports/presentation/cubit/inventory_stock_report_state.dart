import '../../domain/entities/report_filters.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/entities/report_filter_validator.dart';

class CategoryData {
  final String name;
  final int quantity;
  const CategoryData(this.name, this.quantity);
}

class ItemData {
  final String name;
  final String category;
  final int quantity;
  final String status;
  const ItemData(this.name, this.category, this.quantity, this.status);
}

class InventoryStockReportState {
  final ReportFilters filters;
  final List<ItemData> allItems;
  final List<ReportFavorite> favorites;
  final ValidationResult? validationResult;
  final bool isLoadingFavorites;
  final String? favoriteError;

  const InventoryStockReportState({
    required this.filters,
    required this.allItems,
    this.favorites = const [],
    this.validationResult,
    this.isLoadingFavorites = false,
    this.favoriteError,
  });

  // No category filter – only search query
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

  List<CategoryData> get currentPageData {
    if (filters.page == 0) {
      return const [
        CategoryData('Food', 44),
        CategoryData('Kitchen', 20),
        CategoryData('Cleaning', 38),
        CategoryData('Hygiene', 24),
        CategoryData('Bathroom', 30),
      ];
    } else {
      return const [
        CategoryData('Utilities', 64),
        CategoryData('Medicine', 20),
        CategoryData('Laundry', 0),
      ];
    }
  }

  InventoryStockReportState copyWith({
    ReportFilters? filters,
    List<ItemData>? allItems,
    List<ReportFavorite>? favorites,
    ValidationResult? validationResult,
    bool? isLoadingFavorites,
    String? favoriteError,
  }) {
    return InventoryStockReportState(
      filters: filters ?? this.filters,
      allItems: allItems ?? this.allItems,
      favorites: favorites ?? this.favorites,
      validationResult: validationResult ?? this.validationResult,
      isLoadingFavorites: isLoadingFavorites ?? this.isLoadingFavorites,
      favoriteError: favoriteError ?? this.favoriteError,
    );
  }
}