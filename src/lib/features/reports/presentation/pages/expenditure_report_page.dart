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
      ExpenditureCategory(name: 'Food',      amount: 85.50, color: Color(0xFF3A5A40)),
      ExpenditureCategory(name: 'Bathroom',  amount: 32.00, color: Color(0xFFA3B18A)),
      ExpenditureCategory(name: 'Cleaning',  amount: 47.75, color: Color(0xFF6B8F6B)),
      ExpenditureCategory(name: 'Medicine',  amount: 28.00, color: Color(0xFFD4E6D4)),
      ExpenditureCategory(name: 'Utilities', amount: 15.25, color: Color(0xFF4B5563)),
      ExpenditureCategory(name: 'Other',     amount: 12.50, color: Color(0xFFE7E0D6)),
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
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          BlocBuilder<ExpenditureCubit, ExpenditureState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () => _exportPdf(context, state),
                icon: const Icon(Icons.picture_as_pdf, color: Colors.black87),
                tooltip: 'Export to PDF',
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B9D7F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Filters',
                        style:
                            TextStyle(color: Colors.white, fontSize: 14)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down,
                        color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ExpenditureCubit, ExpenditureState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date range metadata
                _DateRangeHeader(
                  startDate: state.startDate,
                  endDate: state.endDate,
                  totalAmount: state.totalAmount,
                ),
                const SizedBox(height: 16),
                // Pie chart
                RepaintBoundary(
                  key: _chartKey,
                  child: _PieChartCard(categories: state.categories),
                ),
                const SizedBox(height: 16),
                // Category breakdown list
                _CategoryBreakdownList(
                  categories: state.categories,
                  totalAmount: state.totalAmount,
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ======================== Widgets ========================

class _DateRangeHeader extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final double totalAmount;

  const _DateRangeHeader({
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
  });

  String _monthName(int month) {
    const names = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return names[month];
  }

  @override
  Widget build(BuildContext context) {
    final dateRange =
        '${_monthName(startDate.month)} ${startDate.day} – ${startDate.day + 6}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateRange,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          '${startDate.year}',
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          'Total Spent: \$${totalAmount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3A5A40),
          ),
        ),
      ],
    );
  }
}

class _PieChartCard extends StatelessWidget {
  final List<ExpenditureCategory> categories;

  const _PieChartCard({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7E0D6)),
      ),
      child: Column(
        children: [
          const Text(
            'Expenditures by Category',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: CustomPaint(
              painter: _PieChartPainter(categories: categories),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 16),
          _PieChartLegend(categories: categories),
        ],
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<ExpenditureCategory> categories;

  _PieChartPainter({required this.categories});

  @override
  void paint(Canvas canvas, Size size) {
    final total = categories.fold(0.0, (sum, c) => sum + c.amount);
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -math.pi / 2;

    for (final category in categories) {
      final sweepAngle = (category.amount / total) * 2 * math.pi;

      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = category.color;

      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);

      // Draw a thin white separator between slices
      final separatorPaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.white
        ..strokeWidth = 2;
      canvas.drawArc(rect, startAngle, sweepAngle, true, separatorPaint);

      startAngle += sweepAngle;
    }

    // Draw centre hole for a donut effect
    final holePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;
    canvas.drawCircle(center, radius * 0.5, holePaint);

    // Draw total amount label in the centre hole
    final total$ = total.toStringAsFixed(0);
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '\$$total$\n',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3A5A40),
            ),
          ),
          const TextSpan(
            text: 'total',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(_PieChartPainter old) => old.categories != categories;
}

class _PieChartLegend extends StatelessWidget {
  final List<ExpenditureCategory> categories;

  const _PieChartLegend({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: categories.map((c) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: c.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              c.name,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _CategoryBreakdownList extends StatelessWidget {
  final List<ExpenditureCategory> categories;
  final double totalAmount;

  const _CategoryBreakdownList({
    required this.categories,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7E0D6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              'Category Breakdown',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (_, i) =>
                _CategoryRow(category: categories[i], total: totalAmount),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final ExpenditureCategory category;
  final double total;

  const _CategoryRow({required this.category, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (category.amount / total * 100) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: category.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category.name,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
              Text(
                '\$${category.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 44,
                child: Text(
                  '${pct.toStringAsFixed(1)}%',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total > 0 ? category.amount / total : 0,
              minHeight: 6,
              backgroundColor: const Color(0xFFE7E0D6),
              valueColor:
                  AlwaysStoppedAnimation<Color>(category.color),
            ),
          ),
        ],
      ),
    );
  }
}
