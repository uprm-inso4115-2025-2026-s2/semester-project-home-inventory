import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/dashboard_repositories.dart';
import '../../domain/entities/item.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<Item> items;
  final String? selectedCategory;
  final String? selectedRoom;
  final DateTime? startDate;
  final DateTime? endDate;

  DashboardLoaded(
    this.items, {
    this.selectedCategory,
    this.selectedRoom,
    this.startDate,
    this.endDate,
  });
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository repository;

  DashboardCubit(this.repository) : super(DashboardInitial());
  // FILTER VARIABLES
  String? _category;
  String? _room;
  DateTime? _startDate;
  DateTime? _endDate;
  Future<void> fetchInitialData() async {
    emit(DashboardLoading());

    try {
      final items = await repository.fetchAllItems();
      emit(DashboardLoaded(items));
    } catch (e) {
      emit(DashboardError("Failed to load dashboard data"));
    }
  }

  Future<void> applyFilters({
    String? category,
    String? room,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Validate date range
    if (startDate != null && endDate != null && startDate.isAfter(endDate)) {
      emit(DashboardError("Invalid date range"));
      return;
    }

    // Save filters
    _category = category;
    _room = room;
    _startDate = startDate;
    _endDate = endDate;

    emit(DashboardLoading());

    try {
      final items = await repository.fetchFilteredItems(
        category: _category,
        room: _room,
        startDate: _startDate,
        endDate: _endDate,
      );

      emit(DashboardLoaded(items));
    } catch (e) {
      emit(DashboardError("Failed to apply filters"));
    }
  }

  Future<void> clearFilters() async {
    _category = null;
    _room = null;
    _startDate = null;
    _endDate = null;

    emit(DashboardLoading());

    try {
      final items = await repository.fetchAllItems();
      emit(DashboardLoaded(items));
    } catch (e) {
      emit(DashboardError("Failed to refresh dashboard"));
    }
  }
}
