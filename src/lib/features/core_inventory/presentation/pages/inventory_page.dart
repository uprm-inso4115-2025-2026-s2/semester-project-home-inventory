import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _categories = const [
    {'id': 'in_stock', 'label': 'In Stock'},
    {'id': 'low_stock', 'label': 'Low Stock'},
    {'id': 'out_of_stock', 'label': 'Out of Stock'},
    {'id': 'custom', 'label': 'Category'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase();
    final filteredCategories = _categories.where((category) {
      return category['label']!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              Center(
                child: Text(
                  'Inventory',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              SizedBox(height: 3.h),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search Item Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (_) {
                  setState(() {});
                },
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredCategories.length,
                  separatorBuilder: (_, __) => SizedBox(height: 2.h),
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];
                    return _InventoryCategoryCard(
                      label: category['label']!,
                      onTap: () {
                        context.go(
                          '/home/inventory/category/${category['id']}',
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InventoryCategoryCard extends StatelessWidget {
  const _InventoryCategoryCard({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 12.h,
      child: ElevatedButton(onPressed: onTap, child: Text(label)),
    );
  }
}
