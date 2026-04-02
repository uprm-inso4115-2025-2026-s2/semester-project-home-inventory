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

  final List<String> _categoryIds = const [
    'in_stock',
    'low_stock',
    'out_of_stock',
    'custom',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase();
    final filteredCategoryIds = _categoryIds.where((categoryId) {
      return _categoryLabel(categoryId).toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search categories or items',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredCategoryIds.length,
                  separatorBuilder: (_, __) => SizedBox(height: 2.h),
                  itemBuilder: (context, index) {
                    final categoryId = filteredCategoryIds[index];

                    return _CategoryCard(
                      label: _categoryLabel(categoryId),
                      onTap: () {
                        context.go('/home/inventory/category/$categoryId');
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

  String _categoryLabel(String categoryId) {
    switch (categoryId) {
      case 'in_stock':
        return 'In Stock';
      case 'low_stock':
        return 'Low Stock';
      case 'out_of_stock':
        return 'Out of Stock';
      case 'custom':
        return 'Category';
      default:
        return 'Category';
    }
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.label, required this.onTap});

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
