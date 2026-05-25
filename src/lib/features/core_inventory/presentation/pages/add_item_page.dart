import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:src/features/auth/presentation/cubit/auth_state.dart';
import 'package:src/features/core_inventory/domain/entities/enums.dart';
import 'package:src/features/core_inventory/domain/entities/stock.dart';
import 'package:src/features/core_inventory/presentation/cubits/inventory_cubit.dart';
import 'package:src/features/core_inventory/presentation/cubits/inventory_state.dart';
import 'package:src/features/core_inventory/presentation/widgets/item_form.dart';

class AddItemPage extends StatelessWidget {
  const AddItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Extract productId from route
    final productId =
        int.tryParse(
          GoRouterState.of(context).pathParameters['productId'] ?? '0',
        ) ??
        0;

    // Get current user's inventory ID (using auth context)
    final authState = context.read<AuthCubit>().state;
    final inventoryId = authState is AuthAuthenticated
        ? int.tryParse(authState.user.id)
        : null;

    if (inventoryId == null) {
      return const Scaffold(
        body: Center(child: Text('Unable to load user information')),
      );
    }

    final safeInventoryId = inventoryId; // Type narrowing for closure

    return Scaffold(
      appBar: AppBar(title: const Text('Add Item')),
      body: BlocListener<InventoryCubit, InventoryState>(
        listener: (context, state) {
          if (state is InventoryLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item added successfully')),
            );
            context.pop();
          } else if (state is InventoryError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: ItemForm(
              submitLabel: 'Save Item',
              onSubmit: (name, details, quantity, expirationDate) {
                // Parse expiration date
                DateTime? expiration;
                if (expirationDate.isNotEmpty) {
                  try {
                    expiration = DateTime.parse(expirationDate);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Invalid expiration date format (use YYYY-MM-DD)',
                        ),
                      ),
                    );
                    return;
                  }
                }

                // Create stock entity
                final stock = StockEntity(
                  id: 0, // Will be assigned by backend
                  brand: details.isNotEmpty ? details : 'Generic',
                  quantity: quantity,
                  status: Status.UNKNOWN,
                  expirationDate: expiration,
                );

                context.read<InventoryCubit>().addStock(
                  safeInventoryId,
                  productId,
                  stock,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
