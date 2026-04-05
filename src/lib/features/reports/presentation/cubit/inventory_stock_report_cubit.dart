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

  InventoryStockReportCubit()
      : super(InventoryStockReportState(
          filters: ReportFilters(  // ✅ Removed 'const' keyword
            startDate: DateTime(2026, 3, 9),
            endDate: DateTime(2026, 3, 15),
            page: 0,
            searchQuery: '',
          ),
          allItems: const [
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
          ],
        )) {
    loadFavorites();
    _validateFiltersDebounced();
  }

  void setStartDate(DateTime date) => _updateFilters(state.filters.copyWith(startDate: date));
  void setEndDate(DateTime date) => _updateFilters(state.filters.copyWith(endDate: date));
  void setPage(int page) => _updateFilters(state.filters.copyWith(page: page));
  void setSearchQuery(String query) => _updateFilters(state.filters.copyWith(searchQuery: query));

  void _updateFilters(ReportFilters newFilters) {
    emit(state.copyWith(filters: newFilters));
    _validateFiltersDebounced();
  }

  void _validateFiltersDebounced() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final result = await _validator.validate(
        state.filters,
        totalAvailableItems: state.filteredItems.length,
      );
      emit(state.copyWith(validationResult: result));
    });
  }

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
    _validateFiltersDebounced();
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}