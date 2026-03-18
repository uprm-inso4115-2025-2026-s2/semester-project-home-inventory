import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class _ReportView extends StatelessWidget {
  const _ReportView();

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
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF8B9D7F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Text('Filters', style: TextStyle(color: Colors.white, fontSize: 14)),
                SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
              ],
            ),
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    Text(
                      '2026',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
              _BarChart(data: state.currentPageData),
              const SizedBox(height: 16),
              Expanded(child: _DataTable(items: state.items)),
              _SearchBar(),
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
    final maxVal = data.isEmpty ? 100 : data.map((e) => e.quantity).reduce((a, b) => a > b ? a : b);
    
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
                final height = (cat.quantity / maxVal * 150).clamp(20.0, 150.0);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('{${cat.quantity}}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black)),
                    const SizedBox(height: 4),
                    Container(
                      width: 40,
                      height: height,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B9D7F),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('{${cat.name}}', style: const TextStyle(fontSize: 11, color: Colors.black)),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Text('< Page ${context.read<ReportCubit>().state.page + 1} >', style: TextStyle(color: Colors.black)),
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
          Expanded(flex: 3, child: Text('Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black))),
          Expanded(flex: 2, child: Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black))),
          Expanded(flex: 1, child: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black))),
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
          Expanded(flex: 3, child: Text('{${item.name}}', style: const TextStyle(fontSize: 12, color: Colors.black))),
          Expanded(flex: 2, child: Text('{${item.category}}', style: const TextStyle(fontSize: 12, color: Colors.black))),
          Expanded(flex: 1, child: Text('{${item.quantity}}', style: const TextStyle(fontSize: 12, color: Colors.black))),
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
      child: Text('{$status}', style: TextStyle(color: colors[1], fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
    );
  }
}

class _SearchBar extends StatelessWidget {
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
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
            child: IconButton(icon: const Icon(Icons.open_in_new, color: Colors.black), onPressed: () {}),
          ),
        ],
      ),
    );
  }
}

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportState());
}

class ReportState {
  final DateTime startDate = DateTime(2026, 3, 9);
  final int page = 0;
  
  List<CategoryData> get currentPageData => page == 0
      ? [
          CategoryData('Food', 44),
          CategoryData('Kitchen', 20),
          CategoryData('Cleaning', 38),
          CategoryData('Hygiene', 24),
          CategoryData('Bathroom', 30),
        ]
      : [
          CategoryData('Utilities', 64),
          CategoryData('Medicine', 20),
          CategoryData('Laundry', 0),
        ];
  
  List<ItemData> get items => [
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
  ];
}

class CategoryData {
  final String name;
  final int quantity;
  CategoryData(this.name, this.quantity);
}

class ItemData {
  final String name;
  final String category;
  final int quantity;
  final String status;
  ItemData(this.name, this.category, this.quantity, this.status);
}
