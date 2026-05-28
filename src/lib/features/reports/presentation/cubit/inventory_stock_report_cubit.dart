import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
          filters: ReportFilters(
            // Default: "as of today" – shows all items up to today
            startDate: DateTime.now(),
            endDate: DateTime.now(),
            page: 0,
            searchQuery: '',
          ),
          allItems: const [],
          isLoading: true,
        )) {
    loadFavorites();
    _validateFiltersDebounced();
    loadInventoryData();
  }

  // ---------- Fetch items: usage_date <= startDate + household filter ----------
  Future<List<ItemData>> _fetchUsageData() async {
    final start = state.filters.startDate;
    final adjustedStart = DateTime(start.year, start.month, start.day + 1);

    // 1. Get current user
    final user = Supabase.instance.client.auth.currentUser;

    // 2. Build query with date filter
    var query = Supabase.instance.client
        .from('usage_rates')
        .select()
        .lt('usage_date', adjustedStart.toIso8601String().split('T').first);

    // 3. Apply household_id filter
    if (user == null) {
      // Guest – only items with household_id IS NULL
      query = query.filter('household_id', 'is', null);
    } else {
      // Logged in – get user's household_id from profiles table
      final profile = await Supabase.instance.client
          .from('profiles')
          .select('household_id')
          .eq('id', user.id)
          .single();

      if (profile != null && profile['household_id'] != null) {
        final householdId = profile['household_id'] as int;
        query = query.eq('household_id', householdId);
      } else {
        // No household assigned – return no items
        return [];
      }
    }

    // 4. Execute query with ordering
    final response = await query.order('category_name');

    // 5. Map to ItemData
    return response.map<ItemData>((row) {
      final categoryName = row['category_name'] as String? ?? '';
      final itemName = row['item_name'] as String?;
      final itemsUsed = (row['items_used'] as int?) ?? 0;
      final rate = (row['usage_rate_percent'] as int?) ?? 0;

      final displayName = (itemName != null && itemName.isNotEmpty) ? itemName : categoryName;

      // Read stored status first
      String status = row['item_status'] as String? ?? '';
      if (status.isEmpty) {
        if (rate >= 95) {
          status = 'OUT OF STOCK';
        } else if (rate >= 80) {
          status = 'LOW';
        } else {
          status = 'OK';
        }
      }

      return ItemData(displayName, categoryName, itemsUsed, status);
    }).toList();
  }

  // ---------- Load data ----------
  Future<void> loadInventoryData() async {
    emit(state.copyWith(isLoading: true, errorMessage: null, warningMessage: null));

    try {
      final items = await _fetchUsageData();
      debugPrint('Loaded ${items.length} items (as of ${state.filters.startDate.toIso8601String()})');
      emit(state.copyWith(allItems: items, isLoading: false));
      _validateFilters();
    } catch (e) {
      debugPrint('Error loading inventory/usage data: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load usage data. Please check your connection.',
      ));
    }
  }

  // ---------- Filter setters ----------
  void setStartDate(DateTime date) {
    _updateFilters(state.filters.copyWith(startDate: date));
  }

  void setEndDate(DateTime date) {
    DateTime clamped = date;
    String? warning;
    final now = DateTime.now();

    if (date.isAfter(now)) {
      clamped = now;
      warning = 'End date cannot be in the future. It has been set to today.';
    }

    // End date doesn't affect the items query (only start date matters now),
    // but we keep the field in the state for completeness / possible future use.
    emit(state.copyWith(filters: state.filters.copyWith(endDate: clamped), warningMessage: warning));
    // No reload needed because end date is not used in the query.
    _validateFiltersDebounced();
  }

  void setPage(int page) => _updateFilters(state.filters.copyWith(page: page));
  void setSearchQuery(String query) => emit(state.copyWith(filters: state.filters.copyWith(searchQuery: query)));

  void _updateFilters(ReportFilters newFilters) {
    emit(state.copyWith(filters: newFilters, warningMessage: null));
    loadInventoryData();   // reload items based on the new start date
    _validateFiltersDebounced();
  }

  // ---------- External validation ----------
  void _validateFilters() async {
    final result = await _validator.validate(
      state.filters,
      totalAvailableItems: state.allItems.length,
    );
    emit(state.copyWith(validationResult: result));
  }

  void _validateFiltersDebounced() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), _validateFilters);
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
    emit(state.copyWith(filters: favorite.filters, warningMessage: null));
    loadInventoryData();
    _validateFiltersDebounced();
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}