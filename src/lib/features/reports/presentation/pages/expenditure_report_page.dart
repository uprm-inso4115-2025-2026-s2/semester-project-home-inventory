//TO DO: REPLACE HARDCODED DATA WITH DATA PULLED FROM BACKEND (SEE LINE 44)

import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/data/services/pdf_export_service.dart';
import '../../../../config/theme.dart';
import '../../domain/entities/report_filters.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../widgets/dynamic_pie_chart.dart';

// ======================== Models ========================

class ExpenditureCategory {
  final String name;
  final double amount;
  final Color color;

  const ExpenditureCategory({
    required this.name,
    required this.amount,
    required this.color,
  });
}

// ======================== State & Cubit ========================

class ExpenditureState {
  final DateTime startDate;
  final DateTime endDate;
  final List<ExpenditureCategory> categories;
  final List<ReportFavorite> favorites;
  final bool isLoadingFavorites;
  final String? favoriteError;

  ExpenditureState({
    DateTime? startDate,
    DateTime? endDate,
    //TO DO: REPLACE HARDCODED DATA WITH BACKEND DATA
    this.categories = const [
      ExpenditureCategory(name: 'Food',      amount: 56.78, color: Color(0xFFF5A623)),
      ExpenditureCategory(name: 'Kitchen',   amount: 45.87, color: Color(0xFF4ECDC4)),
      ExpenditureCategory(name: 'Cleaning',  amount: 20.60, color: Color(0xFF4A90D9)),
      ExpenditureCategory(name: 'Hygiene',   amount: 22.65, color: Color(0xFF7BC67A)),
      ExpenditureCategory(name: 'Bathroom',  amount: 70.96, color: Color(0xFF7B68EE)),
      ExpenditureCategory(name: 'Utilities', amount: 61.67, color: Color(0xFFF08080)),
    ],
    this.favorites = const [],
    this.isLoadingFavorites = false,
    this.favoriteError,
  })  : startDate = startDate ?? DateTime(2026, 3, 9),
        endDate   = endDate   ?? DateTime(2026, 3, 15);

  double get totalAmount =>
      categories.fold(0.0, (sum, c) => sum + c.amount);

  ExpenditureState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<ReportFavorite>? favorites,
    bool? isLoadingFavorites,
    String? favoriteError,
  }) {
    return ExpenditureState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categories: categories,
      favorites: favorites ?? this.favorites,
      isLoadingFavorites: isLoadingFavorites ?? this.isLoadingFavorites,
      favoriteError: favoriteError ?? this.favoriteError,
    );
  }
}

class ExpenditureCubit extends Cubit<ExpenditureState> {
  final FavoritesRepository _favoritesRepository = FavoritesRepository();
  
  ExpenditureCubit() : super(ExpenditureState()) {
    loadFavorites();
  }

  void setStartDate(DateTime date) => emit(state.copyWith(startDate: date));
  void setEndDate(DateTime date) => emit(state.copyWith(endDate: date));

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
      final filters = ReportFilters(
        startDate: state.startDate,
        endDate: state.endDate,
        page: 0,
        searchQuery: '',
      );
      await _favoritesRepository.saveFavorite(name, filters);
      await loadFavorites();
    } catch (e) {
      emit(state.copyWith(favoriteError: 'Failed to save: $e'));
      rethrow;
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
    emit(state.copyWith(
      startDate: favorite.filters.startDate,
      endDate: favorite.filters.endDate,
    ));
  }
}

// ======================== Page ========================

class ExpenditureReportPage extends StatelessWidget {
  const ExpenditureReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpenditureCubit(),
      child: const _ExpenditureView(),
    );
  }
}

// ======================== View ========================

class _ExpenditureView extends StatefulWidget {
  const _ExpenditureView();

  @override
  State<_ExpenditureView> createState() => _ExpenditureViewState();
}

class _ExpenditureViewState extends State<_ExpenditureView> {
  final GlobalKey _chartKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _favoriteNameController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _favoriteNameController.dispose();
    super.dispose();
  }

  Future<Uint8List?> _captureChart() async {
    try {
      final boundary =
          _chartKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  Future<void> _exportPdf(BuildContext context, ExpenditureState state) async {
    final pdfService = PdfExportService();
    final chartImage = await _captureChart();

    final categories = state.categories
        .map((c) => {'name': c.name, 'amount': c.amount})
        .toList();

    await pdfService.exportExpenditureReport(
      startDate: state.startDate,
      endDate: state.endDate,
      categories: categories,
      totalAmount: state.totalAmount,
      chartImage: chartImage,
    );
  }

  void _showSaveFavoriteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Save Current Filters'),
        content: TextField(
          controller: _favoriteNameController,
          decoration: const InputDecoration(hintText: 'Favorite name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final name = _favoriteNameController.text.trim();
              if (name.isEmpty) return;
              try {
                await context.read<ExpenditureCubit>().saveCurrentAsFavorite(name);
                _favoriteNameController.clear();
                if (mounted) Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Favorite saved successfully')),
                );
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteFavorite(BuildContext context, ReportFavorite favorite) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Favorite'),
        content: Text('Are you sure you want to delete "${favorite.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<ExpenditureCubit>().deleteFavorite(favorite.id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryText),
        ),
        title: const Text(
          'Expenditures',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // Favourites dropdown
          BlocBuilder<ExpenditureCubit, ExpenditureState>(
            builder: (context, state) {
              return PopupMenuButton<ReportFavorite>(
                icon: const Icon(Icons.star_border, color: AppTheme.primaryText),
                tooltip: 'Saved filters',
                onSelected: (fav) => context.read<ExpenditureCubit>().applyFavorite(fav),
                itemBuilder: (ctx) {
                  if (state.isLoadingFavorites) {
                    return [const PopupMenuItem(child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator())))];
                  }
                  if (state.favorites.isEmpty) {
                    return [const PopupMenuItem(child: Text('No saved filters'))];
                  }
                  return state.favorites.map((fav) {
                    return PopupMenuItem(
                      value: fav,
                      child: Row(
                        children: [
                          Expanded(child: Text(fav.name)),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                            onPressed: () {
                              Navigator.pop(ctx);
                              _confirmDeleteFavorite(context, fav);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
              );
            },
          ),
          const SizedBox(width: 4),
          // Save current filters button
          IconButton(
            onPressed: () => _showSaveFavoriteDialog(context),
            icon: const Icon(Icons.save_alt, color: AppTheme.primaryText),
            tooltip: 'Save current filters',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ExpenditureCubit, ExpenditureState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date range row with date pickers side by side
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _DatePickerField(
                              label: 'Start Date',
                              value: state.startDate,
                              onChanged: (d) => context.read<ExpenditureCubit>().setStartDate(d!),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DatePickerField(
                              label: 'End Date',
                              value: state.endDate,
                              onChanged: (d) => context.read<ExpenditureCubit>().setEndDate(d!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Chart subtitle
                      const Center(
                        child: Text(
                          'Expenditures Per Category',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.mutedText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Pie chart using fl_chart
                      RepaintBoundary(
                        key: _chartKey,
                        child: DynamicPieChart(categories: state.categories),
                      ),
                      const SizedBox(height: 20),
                      // Table
                      _ExpenditureTable(
                        categories: state.categories,
                        totalAmount: state.totalAmount,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              // Fixed bottom search + export bar
              _BottomBar(
                controller: _searchController,
                onExport: () => _exportPdf(context, state),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ======================== Date Picker Field ========================

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime value;
  final ValueChanged<DateTime?> onChanged;
  const _DatePickerField({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: Text('${value.toLocal()}'.split(' ')[0]),
      ),
    );
  }
}

// ======================== Table ========================

class _ExpenditureTable extends StatelessWidget {
  final List<ExpenditureCategory> categories;
  final double totalAmount;

  const _ExpenditureTable({
    required this.categories,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header row
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Category',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppTheme.primaryText,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Spent',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppTheme.primaryText,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Percentage',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppTheme.primaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Data rows
        ...categories.map((c) {
          final pct = totalAmount > 0
              ? (c.amount / totalAmount * 100).round()
              : 0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    c.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: c.color,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '\$${c.amount.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.primaryText,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '$pct%',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.primaryText,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// ======================== Bottom Bar ========================

class _BottomBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onExport;

  const _BottomBar({required this.controller, required this.onExport});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.borderColor.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: AppTheme.primaryText),
              decoration: InputDecoration(
                hintText: 'Type here to search',
                hintStyle: const TextStyle(color: AppTheme.mutedText),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.open_in_new, color: AppTheme.primaryText),
              onPressed: onExport,
              tooltip: 'Export to PDF',
            ),
          ),
        ],
      ),
    );
  }
}