// TO DO: REPLACE HARDCODED DATA THAT'S USED IN inventory_stock_report_cubit.dart AND
// inventory_stock_report_state.dart, BOTH FILES IN THE CUBIT FOLDER SIBLING OF THE CURRENT PAGES ONE

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/services/pdf_export_service.dart';
import '../../../../core/data/services/pdf_share_helper.dart';
import '../../../../config/theme.dart';
import '../cubit/inventory_stock_report_cubit.dart';
import '../cubit/inventory_stock_report_state.dart';
import '../../domain/entities/report_filter_validator.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../widgets/dynamic_bar_chart.dart';

class InventoryStockReportPage extends StatelessWidget {
  const InventoryStockReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InventoryStockReportCubit(),
      child: const _ReportView(),
    );
  }
}

class _ReportView extends StatefulWidget {
  const _ReportView();

  @override
  State<_ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<_ReportView> {
  final GlobalKey _chartKey = GlobalKey();
  final TextEditingController _favoriteNameController = TextEditingController();

  // ---------- PDF capture & export ----------
  Future<Uint8List?> _captureChart() async {
    try {
      final boundary = _chartKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  Future<void> _exportPdf(BuildContext context, InventoryStockReportState state) async {
    final pdfService = PdfExportService();
    final categories = state.currentPageData
        .map((c) => {'name': c.name, 'quantity': c.quantity})
        .toList();
    final items = state.filteredItems
        .map((i) => {
              'name': i.name,
              'category': i.category,
              'quantity': i.quantity,
              'status': i.status,
            })
        .toList();
    final chartImage = await _captureChart();
    await pdfService.exportInventoryStockReport(
      startDate: state.filters.startDate,
      page: state.filters.page,
      categories: categories,
      items: items,
      chartImage: chartImage,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF exported successfully')),
      );
    }
  }

  Future<void> _sharePdf(BuildContext context, InventoryStockReportState state) async {
    final categories = state.currentPageData
        .map((c) => {'name': c.name, 'quantity': c.quantity})
        .toList();
    final items = state.filteredItems
        .map((i) => {
              'name': i.name,
              'category': i.category,
              'quantity': i.quantity,
              'status': i.status,
            })
        .toList();
    final chartImage = await _captureChart();
    await PdfShareHelper.shareInventoryReport(
      context: context,
      startDate: state.filters.startDate,
      page: state.filters.page,
      categories: categories,
      items: items,
      chartImage: chartImage,
    );
  }

  // ---------- Favourites dialogs ----------
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
                await context.read<InventoryStockReportCubit>().saveCurrentAsFavorite(name);
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

  void _showEditFavoriteDialog(BuildContext context, ReportFavorite favorite) {
    final controller = TextEditingController(text: favorite.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Favorite'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'New name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isEmpty) return;
              await context.read<InventoryStockReportCubit>().updateFavorite(favorite.id, newName);
              Navigator.pop(ctx);
            },
            child: const Text('Rename'),
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
              await context.read<InventoryStockReportCubit>().deleteFavorite(favorite.id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ---------- Generate Report with validation ----------
  void _generateReport(BuildContext context, InventoryStockReportState state) {
    final validation = state.validationResult;
    if (validation == null) return;

    if (validation.hasErrors) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Cannot Generate Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: validation.conflicts
                .where((c) => c.severity == ConflictSeverity.error)
                .map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('• ${c.message}'),
                    ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (validation.hasWarnings) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Performance Warning'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: validation.conflicts
                .where((c) => c.severity == ConflictSeverity.warning)
                .map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('⚠️ ${c.message}\n   Suggestion: ${c.suggestion}'),
                    ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _exportPdf(context, state);
              },
              child: const Text('Generate Anyway'),
            ),
          ],
        ),
      );
    } else {
      _exportPdf(context, state);
    }
  }

  // ---------- Build with Loading / Error / Empty States ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryText),
        ),
        title: const Text(
          'Inventory',
          style: TextStyle(color: AppTheme.primaryText, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        actions: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Star icon - Favourites dropdown
                BlocBuilder<InventoryStockReportCubit, InventoryStockReportState>(
                  builder: (context, state) {
                    return PopupMenuButton<ReportFavorite>(
                      icon: const Icon(Icons.star_border, color: AppTheme.primaryText),
                      tooltip: 'Saved filters',
                      onSelected: (fav) => context.read<InventoryStockReportCubit>().applyFavorite(fav),
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
                                  icon: const Icon(Icons.edit, size: 18),
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    _showEditFavoriteDialog(context, fav);
                                  },
                                ),
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
                const SizedBox(width: 8),
                // Download icon - Save current filters
                IconButton(
                  onPressed: () => _showSaveFavoriteDialog(context),
                  icon: const Icon(Icons.save_alt, color: AppTheme.primaryText),
                  tooltip: 'Save current filters',
                ),
                const SizedBox(width: 8),
                // Share button
                BlocBuilder<InventoryStockReportCubit, InventoryStockReportState>(
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () => _sharePdf(context, state),
                      icon: const Icon(Icons.share, color: AppTheme.primaryText),
                      tooltip: 'Share PDF',
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<InventoryStockReportCubit, InventoryStockReportState>(
        builder: (context, state) {
          // --- Loading state ---
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // --- Error state ---
          if (state.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<InventoryStockReportCubit>().loadInventoryData(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // --- Empty state (data loaded but no items) ---
          if (state.allItems.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No inventory items found for the selected filters.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // --- Normal loaded state ---
          return Column(
            children: [
              // Scrollable content (everything except the bottom search bar)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Filter row: date pickers side by side
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Date pickers side by side in a Row
                            Row(
                              children: [
                                Expanded(
                                  child: _DatePickerField(
                                    label: 'Start Date',
                                    value: state.filters.startDate,
                                    onChanged: (d) => context.read<InventoryStockReportCubit>().setStartDate(d!),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _DatePickerField(
                                    label: 'End Date',
                                    value: state.filters.endDate,
                                    onChanged: (d) => context.read<InventoryStockReportCubit>().setEndDate(d!),
                                  ),
                                ),
                              ],
                            ),
                            // Validation messages
                            if (state.validationResult != null && state.validationResult!.conflicts.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: state.validationResult!.hasErrors ? Colors.red.shade50 : Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: state.validationResult!.conflicts.map((c) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                      child: Row(
                                        children: [
                                          Icon(
                                            c.severity == ConflictSeverity.error ? Icons.error : Icons.warning,
                                            size: 16,
                                            color: c.severity == ConflictSeverity.error ? Colors.red : Colors.orange,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text('${c.message} (${c.suggestion})')),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Chart
                      RepaintBoundary(
                        key: _chartKey,
                        child: DynamicBarChart(data: state.currentPageData),
                      ),
                      const SizedBox(height: 16),
                      // Data table
                      _DataTable(items: state.filteredItems),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              // Search bar with export button
              _SearchBar(onExport: () => _exportPdf(context, state)),
            ],
          );
        },
      ),
    );
  }
}

// ======================== Helper Widgets ========================
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

class _DataTable extends StatelessWidget {
  final List<ItemData> items;
  const _DataTable({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text('No items match your search.', style: TextStyle(color: Colors.black54, fontSize: 14)),
          ),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          _header(),
          const Divider(height: 1),
          Column(
            children: items.map((item) => _row(item)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black))),
          Expanded(flex: 2, child: Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black))),
          Expanded(flex: 1, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black))),
          Expanded(flex: 2, child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black))),
        ],
      ),
    );
  }

  Widget _row(ItemData item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(item.name, style: const TextStyle(fontSize: 12, color: Colors.black))),
          Expanded(flex: 2, child: Text(item.category, style: const TextStyle(fontSize: 12, color: Colors.black))),
          Expanded(flex: 1, child: Text('${item.quantity}', style: const TextStyle(fontSize: 12, color: Colors.black))),
          Expanded(flex: 2, child: _StatusBadge(status: item.status)),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = status == 'OK'
        ? [const Color(0xFFD4EDDA), const Color(0xFF155724)]
        : status == 'LOW'
        ? [const Color(0xFFFFF3CD), const Color(0xFF856404)]
        : [const Color(0xFFF8D7DA), const Color(0xFF721C24)];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(color: colors[0], borderRadius: BorderRadius.circular(4)),
      child: Text(status, style: TextStyle(color: colors[1], fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final VoidCallback onExport;
  const _SearchBar({required this.onExport});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Type here to search',
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                context.read<InventoryStockReportCubit>().setSearchQuery(value);
              },
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.open_in_new, color: Colors.black),
              onPressed: onExport,
              tooltip: 'Export PDF',
            ),
          ),
        ],
      ),
    );
  }
}