import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/data/services/pdf_export_service.dart';

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

  ExpenditureState({
    DateTime? startDate,
    DateTime? endDate,
    this.categories = const [
      ExpenditureCategory(name: 'Food',      amount: 56.78, color: Color(0xFFF5A623)),
      ExpenditureCategory(name: 'Kitchen',   amount: 45.87, color: Color(0xFF4ECDC4)),
      ExpenditureCategory(name: 'Cleaning',  amount: 20.60, color: Color(0xFF4A90D9)),
      ExpenditureCategory(name: 'Hygiene',   amount: 22.65, color: Color(0xFF7BC67A)),
      ExpenditureCategory(name: 'Bathroom',  amount: 70.96, color: Color(0xFF7B68EE)),
      ExpenditureCategory(name: 'Utilities', amount: 61.67, color: Color(0xFFF08080)),
    ],
  })  : startDate = startDate ?? DateTime(2026, 3, 9),
        endDate   = endDate   ?? DateTime(2026, 3, 15);

  double get totalAmount =>
      categories.fold(0.0, (sum, c) => sum + c.amount);

  ExpenditureState copyWith({DateTime? startDate, DateTime? endDate}) {
    return ExpenditureState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categories: categories,
    );
  }
}

class ExpenditureCubit extends Cubit<ExpenditureState> {
  ExpenditureCubit() : super(ExpenditureState());
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

  @override
  void dispose() {
    _searchController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF7EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF7EF),
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: const Text(
          'Expenditures',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                      // Date range row + Filters button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'March ${state.startDate.day} - ${state.endDate.day}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                '${state.startDate.year}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Filters button
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B9D7F),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Filters',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_drop_down,
                                    color: Colors.white, size: 22),
                              ],
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
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Solid pie chart
                      RepaintBoundary(
                        key: _chartKey,
                        child: SizedBox(
                          height: 240,
                          child: CustomPaint(
                            painter: _PieChartPainter(
                                categories: state.categories),
                            child: const SizedBox.expand(),
                          ),
                        ),
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

// ======================== Pie Chart ========================

class _PieChartPainter extends CustomPainter {
  final List<ExpenditureCategory> categories;

  _PieChartPainter({required this.categories});

  @override
  void paint(Canvas canvas, Size size) {
    final total = categories.fold(0.0, (sum, c) => sum + c.amount);
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 4;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -math.pi / 2;

    for (final category in categories) {
      final sweepAngle = (category.amount / total) * 2 * math.pi;

      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = category.color;
      canvas.drawArc(rect, startAngle, sweepAngle, true, fillPaint);

      // White separator line between slices
      final linePaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.white
        ..strokeWidth = 2.5;
      canvas.drawLine(
        center,
        Offset(
          center.dx + radius * math.cos(startAngle),
          center.dy + radius * math.sin(startAngle),
        ),
        linePaint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(_PieChartPainter old) => old.categories != categories;
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
            children: const [
              Expanded(
                flex: 4,
                child: Text(
                  'Category',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
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
                    color: Colors.black87,
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
                    color: Colors.black87,
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
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '$pct%',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
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
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
              icon: const Icon(Icons.open_in_new, color: Colors.black),
              onPressed: onExport,
              tooltip: 'Export to PDF',
            ),
          ),
        ],
      ),
    );
  }
}
