import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/features/core_inventory/presentation/widgets/item_form.dart';
import 'package:src/features/core_inventory/presentation/cubits/edit_item_cubit.dart';

class EditItemPage extends StatelessWidget {
  const EditItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditItemCubit>().state;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Item')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: ItemForm(
            submitLabel: 'Update Item',
            initialName: state.product.name,
            initialDetails: state.product.description,
            initialQuantity: state.stock.quantity,
            initialExpirationDate: _formatDate(state.stock.expirationDate),
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
