import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:src/config/theme.dart';
import '../../../../core/data/services/pdf_export_service.dart';
import '../widgets/dynamic_line_chart.dart';

// ======================== Model ========================

class _UsageItem {
  final String itemName;
  final String categoryName;
  final int itemsUsed;
  final int usageRatePercent;

  const _UsageItem({
    required this.itemName,
    required this.categoryName,
    required this.itemsUsed,
    required this.usageRatePercent,
  });
}

// ======================== Page ========================

class ItemUsageRatesPage extends StatefulWidget {
  const ItemUsageRatesPage({super.key});

  @override
  State<ItemUsageRatesPage> createState() => _ItemUsageRatesPageState();
}

class _ItemUsageRatesPageState extends State<ItemUsageRatesPage> {
  late String _selectedDateRange;
  late List<String> _dateRanges;

  final Set<String> _selectedCategories = {};

  final TextEditingController _searchController = TextEditingController();

  final LayerLink _layerLink = LayerLink();

  String? _overlayState;
  OverlayEntry? _overlayEntry;

  final Map<String, GlobalKey> _chartKeys = {};

  List<_UsageItem> _allItems = [];

  bool _isLoading = true;
  String? _errorMessage;

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  void initState() {
    super.initState();
    _dateRanges = _generateMonthRanges();
    _selectedDateRange = _formatMonth(DateTime.now());
    _searchController.addListener(() => setState(() {}));
    _loadUsageRates();
  }

  @override
  void dispose() {
    _searchController.removeListener(() {});
    _removeOverlay();
    _searchController.dispose();
    super.dispose();
  }

  // ── Date helpers ───────────────────────────────────────────────
  List<String> _generateMonthRanges() {
    final now = DateTime.now();
    final ranges = <String>[];
    for (int month = 1; month <= 12; month++) {
      final date = DateTime(now.year, month, 1);
      ranges.add(_formatMonth(date));
    }
    return ranges;
  }

  String _formatMonth(DateTime date) {
    return '${_monthNames[date.month - 1]} ${date.year}';
  }

  DateTime _getMonthStart(String range) {
    final parts = range.split(' ');
    final monthName = parts[0];
    final year = int.tryParse(parts[1]) ?? DateTime.now().year;
    final month = _monthNames.indexOf(monthName) + 1;
    return DateTime(year, month, 1);
  }

  // ── Supabase data loading (household filter added) ─────────────
  Future<void> _loadUsageRates() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final startDate = _getMonthStart(_selectedDateRange);
      final endDate = DateTime(startDate.year, startDate.month + 1, 1);

      // 1. Get current user
      final user = Supabase.instance.client.auth.currentUser;

      // 2. Build base query with date filters
      var query = Supabase.instance.client
          .from('usage_rates')
          .select()
          .gte('usage_date', startDate.toIso8601String().split('T').first)
          .lt('usage_date', endDate.toIso8601String().split('T').first);

      // 3. Apply household filter
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
          setState(() {
            _allItems = [];
            _selectedCategories.clear();
            _isLoading = false;
          });
          return;
        }
      }

      // 4. Execute query with ordering
      final data = await query.order('category_name');

      final items = data.map<_UsageItem>((row) {
        final catName = row['category_name'] as String? ?? '';
        final itemName = row['item_name'] as String?;
        final displayName =
            (itemName != null && itemName.isNotEmpty) ? itemName : catName;
        return _UsageItem(
          itemName: displayName,
          categoryName: catName,
          itemsUsed: (row['items_used'] as int?) ?? 0,
          usageRatePercent: (row['usage_rate_percent'] as int?) ?? 0,
        );
      }).toList();

      setState(() {
        _allItems = items;
        _selectedCategories
          ..clear()
          ..addAll(items.map((item) => item.categoryName).toSet());
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

  Widget _buildOverlayEntry() {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _closeOverlay,
            child: const SizedBox.expand(),
          ),
        ),
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
          dateRanges: _dateRanges,
          selected: _selectedDateRange,
          onSelect: (range) async {
            setState(() => _selectedDateRange = range);
            _closeOverlay();
            await _loadUsageRates();
          },
        );
      case 'categories':
        return _CategoriesOverlay(
          allCategories:
              _allItems.map((i) => i.categoryName).toSet().toList(),
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

  // ── Chart capture for PDF (first chart) ─────────────────────────
  Future<Uint8List?> _captureChart() async {
    if (_chartKeys.isEmpty) return null;
    try {
      final firstKey = _chartKeys.values.first;
      final boundary = firstKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
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
    final items = _filteredItems
        .map((i) => {
              'name': i.itemName,
              'category': i.categoryName,
              'itemsUsed': i.itemsUsed,
              'usageRate': i.usageRatePercent,
            })
        .toList();
    final chartImage = await _captureChart();
    await pdfService.exportItemUsageRatesReport(
      dateRange: _selectedDateRange,
      categories: items,
      chartImage: chartImage,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF exported successfully')),
      );
    }
  }

  // ── Helpers ────────────────────────────────────────────────────
  List<_UsageItem> get _filteredItems {
    var items = _allItems
        .where((item) => _selectedCategories.contains(item.categoryName))
        .toList();

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      items = items
          .where((item) =>
              item.itemName.toLowerCase().contains(query) ||
              item.categoryName.toLowerCase().contains(query))
          .toList();
    }
    return items;
  }

  Map<String, List<_UsageItem>> get _itemsByCategory {
    final map = <String, List<_UsageItem>>{};
    for (final item in _filteredItems) {
      map.putIfAbsent(item.categoryName, () => []);
      map[item.categoryName]!.add(item);
    }
    return map;
  }

  // ======================== Build ========================
  @override
  Widget build(BuildContext context) {
    _chartKeys.clear();
    for (final cat in _itemsByCategory.keys) {
      _chartKeys[cat] = GlobalKey();
    }

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
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                                const Spacer(),
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
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
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
                                              fontSize: 14,
                                            ),
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
                            if (_allItems.isEmpty)
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
                              if (_itemsByCategory.isNotEmpty) ...[
                                for (final entry in _itemsByCategory.entries)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.primaryText,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height: 200,
                                          child: RepaintBoundary(
                                            key: _chartKeys[entry.key],
                                            child: DynamicLineChart(
                                              points: entry.value
                                                  .map((i) =>
                                                      i.usageRatePercent
                                                          .toDouble())
                                                  .toList(),
                                              days: List<String>.filled(
                                                  entry.value.length, ''),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ] else
                                const Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 24),
                                    child: Text(
                                      'Select at least one category to display charts.',
                                      style: TextStyle(
                                        color: AppTheme.primaryText,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 20),
                              _UsageTable(items: _filteredItems),
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
                      horizontal: 12,
                      vertical: 10,
                    ),
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
                          const Icon(
                            Icons.check,
                            size: 16,
                            color: AppTheme.primaryColor,
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
                            fontSize: 13,
                            color: AppTheme.primaryText,
                          ),
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
  final List<_UsageItem> items;
  const _UsageTable({required this.items});

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
          ...items.map(
            (item) => Column(
              children: [
                _tableRow(item),
                const Divider(height: 1, color: AppTheme.borderColor),
              ],
            ),
          ),
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
            child: Text(
              'Item',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppTheme.primaryText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Category',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppTheme.primaryText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Items Used',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppTheme.primaryText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Usage Rate',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppTheme.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableRow(_UsageItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.itemName,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.primaryText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.categoryName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.primaryText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${item.itemsUsed}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.primaryText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${item.usageRatePercent}%',
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================== Bottom Bar ========================

class _BottomBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onExport;

  const _BottomBar({
    required this.controller,
    required this.onExport,
  });

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
          )
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
                  horizontal: 20,
                  vertical: 12,
                ),
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
              tooltip: 'Export report',
            ),
          ),
        ],
      ),
    );
  }
}