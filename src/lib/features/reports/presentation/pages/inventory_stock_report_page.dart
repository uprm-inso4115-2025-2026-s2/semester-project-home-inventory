import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/data/services/pdf_export_service.dart';
import '../../../../core/data/services/pdf_share_helper.dart';

// ======================== Models ========================
class CategoryData {
  final String name;
  final int quantity;
  const CategoryData(this.name, this.quantity);
}

class ItemData {
  final String name;
  final String category;
  final int quantity;
  final String status;
  const ItemData(this.name, this.category, this.quantity, this.status);
}

// ======================== Cubit & State ========================
class ReportState {
  final DateTime startDate;
  final int page;
  final List<ItemData> allItems;
  final String searchQuery;
  final List<CategoryData> categories;

  ReportState({
    DateTime? startDate,
    this.page = 0,
    this.allItems = const [
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
    this.searchQuery = '',
    this.categories = const [
      CategoryData('Food', 44),
      CategoryData('Kitchen', 20),
      CategoryData('Cleaning', 38),
      CategoryData('Hygiene', 24),
      CategoryData('Bathroom', 30),
    ],
  }) : startDate = startDate ?? DateTime(2026, 3, 9);

  List<ItemData> get filteredItems {
    if (searchQuery.isEmpty) return allItems;
    final lowerQuery = searchQuery.toLowerCase();
    return allItems.where((item) {
      return item.name.toLowerCase().contains(lowerQuery) ||
          item.category.toLowerCase().contains(lowerQuery) ||
          item.status.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  List<CategoryData> get currentPageData {
    if (page == 0) {
      return const [
        CategoryData('Food', 44),
        CategoryData('Kitchen', 20),
        CategoryData('Cleaning', 38),
        CategoryData('Hygiene', 24),
        CategoryData('Bathroom', 30),
      ];
    } else {
      return const [
        CategoryData('Utilities', 64),
        CategoryData('Medicine', 20),
        CategoryData('Laundry', 0),
      ];
    }
  }

  ReportState copyWith({
    DateTime? startDate,
    int? page,
    List<ItemData>? allItems,
    String? searchQuery,
    List<CategoryData>? categories,
  }) {
    return ReportState(
      startDate: startDate ?? this.startDate,
      page: page ?? this.page,
      allItems: allItems ?? this.allItems,
      searchQuery: searchQuery ?? this.searchQuery,
      categories: categories ?? this.categories,
    );
  }
}

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportState());

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}

// ======================== UI ========================
class InventoryStockReportPage extends StatelessWidget {
  const InventoryStockReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportCubit(),
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

  Future<void> _exportPdf(BuildContext context, ReportState state) async {
    final pdfService = PdfExportService();

    final categories = state.currentPageData
        .map((c) => {
      'name': c.name,
      'quantity': c.quantity,
    })
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
      startDate: state.startDate,
      page: state.page,
      categories: categories,
      items: items,
      chartImage: chartImage,
    );
  }

  Future<void> _sharePdf(BuildContext context, ReportState state) async {
    final categories = state.currentPageData
        .map((c) => {
      'name': c.name,
      'quantity': c.quantity,
    })
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
      startDate: state.startDate,
      page: state.page,
      categories: categories,
      items: items,
      chartImage: chartImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F6),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: const Text(
          'Inventory Stock Summary',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          BlocBuilder<ReportCubit, ReportState>(
            builder: (context, state) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _exportPdf(context, state),
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.black87),
                    tooltip: 'Export to PDF',
                  ),
                  IconButton(
                    onPressed: () => _sharePdf(context, state),
                    icon: const Icon(Icons.share, color: Colors.black87),
                    tooltip: 'Share PDF',
                  ),
                ],
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
                    Text(
                      'Filters',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => context.push('/home/reports'),
            icon: const Icon(Icons.list, color: Colors.black87),
            tooltip: 'Go to Reports List',
          ),
        ],
      ),
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'March 9 - 15',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '2026',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
              RepaintBoundary(
                key: _chartKey,
                child: _BarChart(data: state.currentPageData),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _DataTable(items: state.filteredItems),
              ),
              const _SearchBar(),
            ],
          );
        },
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<CategoryData> data;
  const _BarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxVal = data.isEmpty
        ? 100
        : data.map((e) => e.quantity).reduce((a, b) => a > b ? a : b);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: data.map((cat) {
                final height =
                (cat.quantity / maxVal * 150).clamp(20.0, 150.0);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${cat.quantity}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 40,
                      height: height,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B9D7F),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat.name,
                      style: const TextStyle(fontSize: 11, color: Colors.black),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '< Page ${context.read<ReportCubit>().state.page + 1} >',
            style: const TextStyle(color: Colors.black),
          ),
        ],
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
          color: const Color(0xFFFAF9F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'No items match your search.',
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          _header(),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) => _row(items[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: const [
          Expanded(
            flex: 3,
            child: Text(
              'Items',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Category',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Quantity',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Status',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(ItemData item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.name,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.category,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${item.quantity}',
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          Expanded(
            flex: 2,
            child: _StatusBadge(status: item.status),
          ),
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
      decoration: BoxDecoration(
        color: colors[0],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: colors[1],
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Type here to search',
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black54),
                  onPressed: () {
                    _controller.clear();
                    context.read<ReportCubit>().search('');
                    setState(() {});
                  },
                )
                    : null,
              ),
              onChanged: (value) {
                context.read<ReportCubit>().search(value);
                setState(() {});
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
              onPressed: () {
              },
            ),
          ),
        ],
      ),
    );
  }
}