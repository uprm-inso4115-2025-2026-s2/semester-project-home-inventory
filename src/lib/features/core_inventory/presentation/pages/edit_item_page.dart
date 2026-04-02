import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/core_inventory/domain/entities/enums.dart';
import 'package:src/features/core_inventory/domain/entities/product.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';
import 'package:src/features/core_inventory/presentation/mock_data/sample_data.dart';
import 'package:src/features/core_inventory/presentation/widgets/item_form.dart';

class EditItemPage extends StatelessWidget {
  const EditItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final itemId =
        int.tryParse(
          GoRouterState.of(context).pathParameters['itemId'] ?? '',
        ) ??
        0;

    final inventory = buildSampleInventory();
    final pair = findProductAndStockByStockId(inventory, itemId);

    final product =
        pair?.key ??
        const ProductEntity(id: 0, name: 'Item', description: 'Item details');

    final stock =
        pair?.value ??
        const StockEntity(
          id: 0,
          brand: 'Generic',
          quantity: 1,
          status: Status.UNKNOWN,
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Item')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: ItemForm(
            submitLabel: 'Update Item',
            initialName: product.name,
            initialDetails: product.description,
            initialQuantity: stock.quantity,
            initialExpirationDate: _formatDate(stock.expirationDate),
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

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
