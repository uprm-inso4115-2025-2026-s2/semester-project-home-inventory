import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/core_inventory/presentation/widgets/item_form.dart';

class EditItemPage extends StatelessWidget {
  const EditItemPage({
    super.key,
    required this.categoryId,
    required this.itemId,
  });

  final String categoryId;
  final String itemId;

  @override
  Widget build(BuildContext context) {
    final initialData = _sampleItem(itemId);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Item')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: ItemForm(
            submitLabel: 'Update Item',
            initialName: initialData['name']!,
            initialDetails: initialData['details']!,
            initialQuantity: int.parse(initialData['quantity']!),
            initialExpirationDate: initialData['expirationDate']!,
            onSubmit: (name, details, quantity, expirationDate) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Updated item input captured')),
              );
              context.pop();
            },
          ),
        ),
      ),
    );
  }

  Map<String, String> _sampleItem(String id) {
    switch (id) {
      case '1':
        return {
          'name': 'Rice',
          'details': 'Long grain rice',
          'quantity': '5',
          'expirationDate': '2026-08-15',
        };
      case '3':
        return {
          'name': 'Milk',
          'details': 'Whole milk',
          'quantity': '1',
          'expirationDate': '2026-04-03',
        };
      default:
        return {
          'name': 'Item',
          'details': 'Item details',
          'quantity': '1',
          'expirationDate': '',
        };
    }
  }
}
