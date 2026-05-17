// TO DO: REPLACE HARDCODED DATA WITH DATA PULLED FROM BACKEND (SEE LINE 47)

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/report_filters.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/entities/report_filter_validator.dart';
import 'inventory_stock_report_state.dart';

class InventoryStockReportCubit extends Cubit<InventoryStockReportState> {
  final FavoritesRepository _favoritesRepository = FavoritesRepository();
  final ReportFilterValidator _validator = ReportFilterValidator();
  Timer? _debounceTimer;

  // For simulating network delay (can be removed later)
  static const bool _simulateError = false; // set to true to test error state

  InventoryStockReportCubit()
      : super(InventoryStockReportState(
          filters: ReportFilters(
            startDate: DateTime(2026, 3, 9),
            endDate: DateTime(2026, 3, 15),
            page: 0,
            searchQuery: '',
          ),
          allItems: const [], // start empty; will be filled by loadInventoryData
          isLoading: true,    // show spinner immediately
        )) {
    loadFavorites();
    _validateFiltersDebounced();
    loadInventoryData(); // load initial data
  }

  // ---------- Data fetching (simulated) ----------
  /// Simulates an asynchronous fetch of inventory items.
  /// Replace this with a real Supabase call later.
  Future<List<ItemData>> _fetchInventoryData() async {
    // Simulate network delay (500-1000ms)
    await Future.delayed(const Duration(milliseconds: 800));

    // Optional: simulate error for testing
    if (_simulateError) {
      throw Exception('Simulated network failure');
    }

    // Return the hardcoded demo data
    //TO DO: REPLACE HARDCODED DATA WITH DATA PULLED FROM BACKEND (potentially also update line 21-22 dates)
    return const [
      ItemData('Eggs', 'Food', 18, 'OK'),
      ItemData('Beans (cans)', 'Food', 15, 'OK'),
      ItemData('Rice (bags)', 'Food', 1, 'LOW'),
      ItemData('Meat (packs)', 'Food', 9, 'OK'),
      ItemData('Cereal (boxes)', 'Food', 0, 'OUT OF STOCK'),
      ItemData('Bananas', 'Food', 2, 'LOW'),
      ItemData('Batteries AA', 'Utilities', 25, 'OK'),
      ItemData('Batteries AAA', 'Utilities', 19, 'OK'),
      ItemData('Advil (pills)', 'Medicine', 1, 'LOW'),
      ItemData('Throat lozenges', 'Medicine', 19, 'OK'),
      ItemData('Laundry detergent', 'Laundry', 0, 'OUT OF STOCK'),
    ];
  }

  /// Load inventory data from the (simulated) source.
  /// Sets loading state, fetches data, and updates state or shows error.
  Future<void> loadInventoryData() async {
  // No guard – allow fetching even if already loading
  emit(state.copyWith(isLoading: true, errorMessage: null));

  try {
    final items = await _fetchInventoryData();
    emit(state.copyWith(allItems: items, isLoading: false));
    _validateFilters();
  } catch (e) {
    emit(state.copyWith(
      allItems: const [],
      isLoading: false,
      errorMessage: 'Unable to load inventory data. Please check your connection and try again.',
    ));
  }
}

  // ---------- Filter methods ----------
  void setStartDate(DateTime date) => _updateFilters(state.filters.copyWith(startDate: date));
  void setEndDate(DateTime date) => _updateFilters(state.filters.copyWith(endDate: date));
  void setPage(int page) => _updateFilters(state.filters.copyWith(page: page));
  void setSearchQuery(String query) => _updateFilters(state.filters.copyWith(searchQuery: query));

  void _updateFilters(ReportFilters newFilters) {
    emit(state.copyWith(filters: newFilters));
    loadInventoryData(); // refetch data with new filters
    _validateFiltersDebounced();
  }

  // ---------- Validation ----------
  void _validateFilters() async {
    final result = await _validator.validate(
      state.filters,
      totalAvailableItems: state.allItems.length, // use loaded items count
    );
    emit(state.copyWith(validationResult: result));
  }

  void _validateFiltersDebounced() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _validateFilters();
    });
  }

  // ---------- Favorites (unchanged) ----------
  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoadingFavorites: true, favoriteError: null));
    try {
      final favs = await _favoritesRepository.getUserFavorites();
      emit(state.copyWith(favorites: favs, isLoadingFavorites: false));
    } catch (e) {
      emit(state.copyWith(isLoadingFavorites: false, favoriteError: e.toString()));
    }
  }

  Future<void> saveCurrentAsFavorite(String name) async {
    try {
      await _favoritesRepository.saveFavorite(name, state.filters);
      await loadFavorites();
    } catch (e) {
      emit(state.copyWith(favoriteError: 'Failed to save: $e'));
      rethrow;
    }
  }

  Future<void> updateFavorite(String id, String newName) async {
    try {
      await _favoritesRepository.updateFavorite(id, newName, state.filters);
      await loadFavorites();
    } catch (e) {
      emit(state.copyWith(favoriteError: 'Failed to update: $e'));
    }
  }

  Future<void> deleteFavorite(String id) async {
    try {
      await _favoritesRepository.deleteFavorite(id);
      await loadFavorites();
    } catch (e) {
      emit(state.copyWith(favoriteError: 'Failed to delete: $e'));
    }
  }

  void applyFavorite(ReportFavorite favorite) {
    emit(state.copyWith(filters: favorite.filters));
    loadInventoryData(); // load data for the new filters
    _validateFiltersDebounced();
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}