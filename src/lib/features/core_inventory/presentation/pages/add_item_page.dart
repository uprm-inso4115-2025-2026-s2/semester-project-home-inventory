import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/core_inventory/presentation/widgets/item_form.dart';

class AddItemPage extends StatelessWidget {
  const AddItemPage({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Item')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: ItemForm(
            submitLabel: 'Save Item',
            onSubmit: (name, details, quantity, expirationDate) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item input captured')),
              );
              context.pop();
            },
          ),
        ),
      ),
    );
  }
}
