import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:src/config/theme.dart';
import '../../../../core/data/services/pdf_export_service.dart';
import '../widgets/dynamic_line_chart.dart';

// ======================== Models ========================

class _UsageCategory {
  final String name;
  final int itemsUsed;
  final int usageRatePercent;

  const _UsageCategory({
    required this.name,
    required this.itemsUsed,
    required this.usageRatePercent,
  });
}

// ======================== Date Range Data ========================

const _kDateRanges = [
  'January 2026',
  'February 2026',
  'March 2026',
  'April 2026',
  'May 2026',
  'June 2026',
  'July 2026',
  'August 2026',
  'September 2026',
  'October 2026',
  'November 2026',
  'December 2026',
];

// ======================== Page ========================

class ItemUsageRatesPage extends StatefulWidget {
  const ItemUsageRatesPage({super.key});

  @override
  State<ItemUsageRatesPage> createState() => _ItemUsageRatesPageState();
}

class _ItemUsageRatesPageState extends State<ItemUsageRatesPage> {
  String _selectedDateRange = 'March 2026';

  final Set<String> _selectedCategories = {};

  final TextEditingController _searchController = TextEditingController();

  // LayerLink anchors the overlay to the Filters button
  final LayerLink _layerLink = LayerLink();

  // Overlay state: null | 'main' | 'dateRange' | 'categories'
  String? _overlayState;
  OverlayEntry? _overlayEntry;

  // Key for capturing the chart
  final GlobalKey _chartKey = GlobalKey();

  List<_UsageCategory> _allCategories = [];
  List<double> _chartPoints = [];
  List<String> _chartLabels = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsageRates();
  }

  @override
  void dispose() {
    _removeOverlay();
    _searchController.dispose();
    super.dispose();
  }

  // ── Supabase data loading ──────────────────────────────────────

  DateTime _getMonthStart(String range) {
    switch (range) {
      case 'January 2026':
        return DateTime(2026, 1, 1);
      case 'February 2026':
        return DateTime(2026, 2, 1);
      case 'March 2026':
        return DateTime(2026, 3, 1);
      case 'April 2026':
        return DateTime(2026, 4, 1);
      case 'May 2026':
        return DateTime(2026, 5, 1);
      case 'June 2026':
        return DateTime(2026, 6, 1);
      case 'July 2026':
        return DateTime(2026, 7, 1);
      case 'August 2026':
        return DateTime(2026, 8, 1);
      case 'September 2026':
        return DateTime(2026, 9, 1);
      case 'October 2026':
        return DateTime(2026, 10, 1);
      case 'November 2026':
        return DateTime(2026, 11, 1);
      case 'December 2026':
        return DateTime(2026, 12, 1);
      default:
        return DateTime(2026, 3, 1);
    }
  }

  Future<void> _loadUsageRates() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final startDate = _getMonthStart(_selectedDateRange);
      final endDate = DateTime(startDate.year, startDate.month + 1, 1);

      final data = await Supabase.instance.client
          .from('usage_rates')
          .select()
          .gte('usage_date', startDate.toIso8601String().split('T').first)
          .lt('usage_date', endDate.toIso8601String().split('T').first)
          .order('category_name');

      final categories = data.map<_UsageCategory>((row) {
        return _UsageCategory(
          name: row['category_name'] ?? '',
          itemsUsed: row['items_used'] ?? 0,
          usageRatePercent: row['usage_rate_percent'] ?? 0,
        );
      }).toList();

      setState(() {
        _allCategories = categories;

        _chartPoints = categories
            .map((category) => category.usageRatePercent.toDouble())
            .toList();

        _chartLabels = categories.map((category) => category.name).toList();

        _selectedCategories
          ..clear()
          ..addAll(categories.map((category) => category.name));

        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _errorMessage = 'Failed to load usage rate data';
        _isLoading = false;
      });
    }
  }

  // ── Overlay management ─────────────────────────────────────────

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _closeOverlay() {
    _removeOverlay();
    if (mounted) setState(() => _overlayState = null);
  }

  void _showOverlay(String state) {
    _removeOverlay();
    setState(() => _overlayState = state);

    final entry = OverlayEntry(builder: (_) => _buildOverlayEntry());
    _overlayEntry = entry;
    Overlay.of(context).insert(entry);
  }

  void _setOverlayState(String state) {
    setState(() => _overlayState = state);
    _overlayEntry?.markNeedsBuild();
  }

  // ── Build overlay widget tree ──────────────────────────────────

  Widget _buildOverlayEntry() {
    return Stack(
      children: [
        // Full-screen tap barrier to dismiss
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _closeOverlay,
            child: const SizedBox.expand(),
          ),
        ),
        // Overlay anchored to the Filters button (bottom-right aligned)
        CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomRight,
          followerAnchor: Alignment.topRight,
          offset: const Offset(0, 4),
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {},
              child: _buildOverlayContent(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlayContent() {
    switch (_overlayState) {
      case 'main':
        return _MainFilterOverlay(
          onDateRange: () => _setOverlayState('dateRange'),
          onCategories: () => _setOverlayState('categories'),
        );
      case 'dateRange':
        return _DateRangeOverlay(
          dateRanges: _kDateRanges,
          selected: _selectedDateRange,
          onSelect: (range) async {
            setState(() => _selectedDateRange = range);
            _closeOverlay();
            await _loadUsageRates();
          },
        );
      case 'categories':
        return _CategoriesOverlay(
          allCategories: _allCategories.map((c) => c.name).toList(),
          selected: _selectedCategories,
          onToggle: (name) {
            setState(() {
              if (_selectedCategories.contains(name)) {
                if (_selectedCategories.length > 1) {
                  _selectedCategories.remove(name);
                }
              } else {
                _selectedCategories.add(name);
              }
            });
            _overlayEntry?.markNeedsBuild();
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // ── Chart capture for PDF ───────────────────────────────────────

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

  // ── PDF export ─────────────────────────────────────────────────

  Future<void> _exportPdf() async {
    final pdfService = PdfExportService();
    final categories = _filteredCategories
        .map((c) => {
      'name': c.name,
      'itemsUsed': c.itemsUsed,
      'usageRate': c.usageRatePercent,
    })
        .toList();

    final chartImage = await _captureChart();

    await pdfService.exportItemUsageRatesReport(
      dateRange: _selectedDateRange,
      categories: categories,
      chartImage: chartImage,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF exported successfully')),
      );
    }
  }

  // ── Helpers ────────────────────────────────────────────────────

  List<_UsageCategory> get _filteredCategories => _allCategories
      .where((c) => _selectedCategories.contains(c.name))
      .toList();

  List<double> get _filteredChartPoints => _filteredCategories
      .map((category) => category.usageRatePercent.toDouble())
      .toList();

  List<String> get _filteredChartLabels =>
      _filteredCategories.map((category) => category.name).toList();

  // ======================== Build ========================

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
          'Item Usage Rates',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: AppTheme.primaryText),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date range + Filters button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date range display
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedDateRange,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryText,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Filters button
                      CompositedTransformTarget(
                        link: _layerLink,
                        child: GestureDetector(
                          onTap: () {
                            if (_overlayState != null) {
                              _closeOverlay();
                            } else {
                              _showOverlay('main');
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Filters',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  _overlayState != null
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (_allCategories.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          'No usage rate data available for this month.',
                          style: TextStyle(
                            color: AppTheme.primaryText,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  else ...[
                    // Line chart
                    RepaintBoundary(
                      key: _chartKey,
                      child: DynamicLineChart(
                        points: _filteredChartPoints,
                        days: _filteredChartLabels,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Table
                    _UsageTable(categories: _filteredCategories),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
          _BottomBar(
            controller: _searchController,
            onExport: _exportPdf,
          ),
        ],
      ),
    );
  }
}

// ======================== Overlay Widgets ========================

/// First level: "Date Range ▶" and "Show Categories ▶"
class _MainFilterOverlay extends StatelessWidget {
  final VoidCallback onDateRange;
  final VoidCallback onCategories;

  const _MainFilterOverlay({
    required this.onDateRange,
    required this.onCategories,
  });

  @override
  Widget build(BuildContext context) {
    return _OverlayCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FilterMenuButton(label: 'Date Range', onTap: onDateRange),
          const SizedBox(height: 8),
          _FilterMenuButton(label: 'Show Categories', onTap: onCategories),
        ],
      ),
    );
  }
}

/// Second level: mutually exclusive date range selection
class _DateRangeOverlay extends StatelessWidget {
  final List<String> dateRanges;
  final String selected;
  final ValueChanged<String> onSelect;

  const _DateRangeOverlay({
    required this.dateRanges,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return _OverlayCard(
      child: SizedBox(
        width: 180,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: dateRanges.map((range) {
                final isSelected = range == selected;
                return GestureDetector(
                  onTap: () => onSelect(range),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor.withOpacity(0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            range,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.primaryText,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check,
                              size: 16, color: AppTheme.primaryColor),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Second level: multi-select category checkboxes
class _CategoriesOverlay extends StatelessWidget {
  final List<String> allCategories;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _CategoriesOverlay({
    required this.allCategories,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return _OverlayCard(
      child: SizedBox(
        width: 200,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 320),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: allCategories.map((name) {
                final isChecked = selected.contains(name);
                return GestureDetector(
                  onTap: () => onToggle(name),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: isChecked,
                            onChanged: (_) => onToggle(name),
                            activeColor: AppTheme.primaryColor,
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 13, color: AppTheme.primaryText),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shared card container for all overlay levels
class _OverlayCard extends StatelessWidget {
  final Widget child;
  const _OverlayCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(10),
      color: AppTheme.surfaceColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: child,
      ),
    );
  }
}

/// A single menu item button inside the main filter overlay
class _FilterMenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _FilterMenuButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(Icons.arrow_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// ======================== Usage Table ========================

class _UsageTable extends StatelessWidget {
  final List<_UsageCategory> categories;
  const _UsageTable({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          _tableHeader(),
          const Divider(height: 1, color: AppTheme.borderColor),
          ...categories.map((cat) => Column(
            children: [
              _tableRow(cat),
              const Divider(height: 1, color: AppTheme.borderColor),
            ],
          )),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text('Category',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppTheme.primaryText))),
          Expanded(
              flex: 2,
              child: Text('Items Used',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppTheme.primaryText))),
          Expanded(
              flex: 2,
              child: Text('Usage Rate',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppTheme.primaryText))),
        ],
      ),
    );
  }

  Widget _tableRow(_UsageCategory cat) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(cat.name,
                  style: const TextStyle(
                      fontSize: 13, color: AppTheme.primaryText))),
          Expanded(
              flex: 2,
              child: Text('${cat.itemsUsed}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13, color: AppTheme.primaryText))),
          Expanded(
              flex: 2,
              child: Text('${cat.usageRatePercent}%',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontSize: 13, color: AppTheme.primaryText))),
        ],
      ),
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
              offset: const Offset(0, -2))
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
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
              ),
              // TO DO: Wire up search to filter table rows once backend is connected
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
              tooltip: 'Export report',
            ),
          ),
        ],
      ),
    );
  }
}