import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:src/config/theme.dart';
import '../../../../core/data/services/pdf_export_service.dart';

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

// ======================== Static Sample Data ========================

const _kAllCategories = [
  _UsageCategory(name: 'Food',      itemsUsed: 25, usageRatePercent: 30),
  _UsageCategory(name: 'Kitchen',   itemsUsed: 5,  usageRatePercent: 10),
  _UsageCategory(name: 'Cleaning',  itemsUsed: 1,  usageRatePercent: 1),
  _UsageCategory(name: 'Hygiene',   itemsUsed: 15, usageRatePercent: 30),
  _UsageCategory(name: 'Bathroom',  itemsUsed: 3,  usageRatePercent: 10),
  _UsageCategory(name: 'Utilities', itemsUsed: 2,  usageRatePercent: 30),
  _UsageCategory(name: 'Medicine',  itemsUsed: 2,  usageRatePercent: 30),
  _UsageCategory(name: 'Laundry',   itemsUsed: 1,  usageRatePercent: 5),
];

// Static line chart data points (Mon–Sun), range 0–30
const _kChartPoints = [10.0, 15.0, 22.0, 21.0, 12.0, 8.0, 5.0];
const _kChartDays   = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

const _kDateRanges = [
  'Mar 16 - 20',
  'Mar 9 - 15',
  'Mar 2 - 8',
  'Feb 23 - Mar 1',
  'Feb 16 - 22',
  'Feb 9 - 15',
  'Feb 2 - 8',
];

// ======================== Page ========================

class ItemUsageRatesPage extends StatefulWidget {
  const ItemUsageRatesPage({super.key});

  @override
  State<ItemUsageRatesPage> createState() => _ItemUsageRatesPageState();
}

class _ItemUsageRatesPageState extends State<ItemUsageRatesPage> {
  String _selectedDateRange = 'Mar 9 - 15';
  final Set<String> _selectedCategories = {
    'Food', 'Kitchen', 'Cleaning', 'Hygiene',
    'Bathroom', 'Utilities', 'Medicine', 'Laundry',
  };

  final TextEditingController _searchController = TextEditingController();

  // LayerLink anchors the overlay to the Filters button
  final LayerLink _layerLink = LayerLink();

  // Overlay state: null | 'main' | 'dateRange' | 'categories'
  String? _overlayState;
  OverlayEntry? _overlayEntry;

  // Key for capturing the chart
  final GlobalKey _chartKey = GlobalKey();

  @override
  void dispose() {
    _removeOverlay();
    _searchController.dispose();
    super.dispose();
  }

  // ── Overlay management ─────────────────────────────────────────

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    // Don't call setState here — may be called during dispose
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
    // Rebuild the existing entry in place
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
              // Prevent taps inside the overlay from hitting the barrier
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
          onSelect: (range) {
            setState(() => _selectedDateRange = range);
            _closeOverlay();
          },
        );
      case 'categories':
        return _CategoriesOverlay(
          allCategories: _kAllCategories.map((c) => c.name).toList(),
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
      final boundary = _chartKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
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
        .map((c) => {'name': c.name, 'itemsUsed': c.itemsUsed, 'usageRate': c.usageRatePercent})
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

  List<_UsageCategory> get _filteredCategories => _kAllCategories
      .where((c) => _selectedCategories.contains(c.name))
      .toList();

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
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: const Text(
          'Item Usage Rates',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date range + Filters button row
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
                              color: Colors.black87,
                            ),
                          ),
                          const Text(
                            '2026',
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Filters button — anchored with CompositedTransformTarget
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
                                      color: Colors.white, fontSize: 14),
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
                  // Line chart wrapped with RepaintBoundary for capturing
                  RepaintBoundary(
                    key: _chartKey,
                    child: _LineChart(points: _kChartPoints, days: _kChartDays),
                  ),
                  const SizedBox(height: 20),
                  // Table
                  _UsageTable(categories: _filteredCategories),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          // Fixed bottom bar
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
                          style: TextStyle(
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

// ======================== Line Chart ========================

class _LineChart extends StatelessWidget {
  final List<double> points;
  final List<String> days;

  const _LineChart({required this.points, required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: SizedBox(
        height: 200,
        child: CustomPaint(
          painter: _LineChartPainter(points: points, days: days),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> points;
  final List<String> days;

  const _LineChartPainter({required this.points, required this.days});

  @override
  void paint(Canvas canvas, Size size) {
    const double paddingLeft = 32;
    const double paddingBottom = 24;
    const double paddingTop = 12;
    const double paddingRight = 8;

    final chartW = size.width - paddingLeft - paddingRight;
    final chartH = size.height - paddingBottom - paddingTop;

    const double maxY = 30;
    const double minY = 0;

    final gridPaint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;

    final labelStyle = const TextStyle(
      fontSize: 10,
      color: Colors.black54,
    );

    for (final yVal in [0, 10, 20, 30]) {
      final y = paddingTop + chartH * (1 - (yVal - minY) / (maxY - minY));
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );
      final tp = TextPainter(
        text: TextSpan(text: '$yVal', style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    for (int i = 0; i < days.length; i++) {
      final x = paddingLeft + (i / (days.length - 1)) * chartW;
      final tp = TextPainter(
        text: TextSpan(text: days[i], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(x - tp.width / 2, size.height - paddingBottom + 6),
      );
    }

    final linePaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppTheme.backgroundColor
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    final List<Offset> dotPositions = [];

    for (int i = 0; i < points.length; i++) {
      final x = paddingLeft + (i / (points.length - 1)) * chartW;
      final y = paddingTop + chartH * (1 - (points[i] - minY) / (maxY - minY));
      final offset = Offset(x, y);
      dotPositions.add(offset);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);

    for (final pos in dotPositions) {
      canvas.drawCircle(pos, 5, dotPaint);
      canvas.drawCircle(pos, 5, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      old.points != points || old.days != days;
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
                      color: Colors.black87))),
          Expanded(
              flex: 2,
              child: Text('Items Used',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black87))),
          Expanded(
              flex: 2,
              child: Text('Usage Rate',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black87))),
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
                  style: const TextStyle(fontSize: 13, color: Colors.black87))),
          Expanded(
              flex: 2,
              child: Text('${cat.itemsUsed}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.black87))),
          Expanded(
              flex: 2,
              child: Text('${cat.usageRatePercent}%',
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 13, color: Colors.black87))),
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
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Type here to search',
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
              ),
              // TODO: Wire up search to filter table rows once backend is connected
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
              tooltip: 'Export report',
            ),
          ),
        ],
      ),
    );
  }
}