import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class InventoryCategoryPage extends StatelessWidget {
  const InventoryCategoryPage({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final title = _categoryTitle(categoryId);
    final items = _sampleItemsForCategory(categoryId);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 3.w,
                runSpacing: 1.h,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        '/home/inventory/category/$categoryId/labels',
                      );
                    },
                    child: const Text('Item Label Key'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.push('/home/inventory/category/$categoryId/add');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item'),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 1.5.h),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _ItemCard(
                      name: item['name']!,
                      quantity: item['quantity']!,
                      expirationDate: item['expirationDate']!,
                      status: item['status']!,
                      onEdit: () {
                        context.push(
                          '/home/inventory/category/$categoryId/edit/${item['id']}',
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

  String _categoryTitle(String id) {
    switch (id) {
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

  List<Map<String, String>> _sampleItemsForCategory(String id) {
    switch (id) {
      case 'in_stock':
        return const [
          {
            'id': '1',
            'name': 'Rice',
            'quantity': '5',
            'expirationDate': '2026-08-15',
            'status': 'FULL',
          },
          {
            'id': '2',
            'name': 'Beans',
            'quantity': '3',
            'expirationDate': '2026-07-01',
            'status': 'HALFWAY',
          },
        ];
      case 'low_stock':
        return const [
          {
            'id': '3',
            'name': 'Milk',
            'quantity': '1',
            'expirationDate': '2026-04-03',
            'status': 'LOW',
          },
          {
            'id': '4',
            'name': 'Bread',
            'quantity': '1',
            'expirationDate': '2026-04-01',
            'status': 'LOW',
          },
        ];
      case 'out_of_stock':
        return const [
          {
            'id': '5',
            'name': 'Eggs',
            'quantity': '0',
            'expirationDate': 'N/A',
            'status': 'EMPTY',
          },
        ];
      default:
        return const [
          {
            'id': '6',
            'name': 'Soap',
            'quantity': '2',
            'expirationDate': 'N/A',
            'status': 'UNKNOWN',
          },
        ];
    }
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.name,
    required this.quantity,
    required this.expirationDate,
    required this.status,
    required this.onEdit,
  });

  final String name;
  final String quantity;
  final String expirationDate;
  final String status;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 1.h),
            Text('Quantity: $quantity'),
            Text('Earliest Expiration Date: $expirationDate'),
            Text('Status: $status'),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
