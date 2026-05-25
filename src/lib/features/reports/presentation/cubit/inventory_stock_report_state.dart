// TO DO: REPLACE HARDCODED DATA WITH REAL DATA PULLED FROM BACKEND (SEE LINE 57)

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

  // NEW: loading and error states for inventory data
  final bool isLoading;
  final String? errorMessage;

  const InventoryStockReportState({
    required this.filters,
    required this.allItems,
    this.favorites = const [],
    this.validationResult,
    this.isLoadingFavorites = false,
    this.favoriteError,
    this.isLoading = false,
    this.errorMessage,
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

  // TO DO: REPLACE HARDCODED DATA HERE AND IN inventory_stock_report_cubit.dart
  List<CategoryData> get currentPageData {
    // Return ALL categories for scrolling instead of pagination
    return const [
      CategoryData('Food', 44),
      CategoryData('Kitchen', 20),
      CategoryData('Cleaning', 38),
      CategoryData('Hygiene', 24),
      CategoryData('Bathroom', 30),
      CategoryData('Utilities', 64),
      CategoryData('Medicine', 20),
      CategoryData('Laundry', 0),
    ];
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
    );
  }
}