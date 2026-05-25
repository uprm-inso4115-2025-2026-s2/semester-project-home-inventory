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
import 'package:src/features/core_inventory/presentation/utils/error_handler.dart'; // Add this import

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
              const SnackBar(
                content: Text('Item added successfully'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          } else if (state is InventoryError) {
            // Use the error handler to show friendly message
            InventoryErrorHandler.showErrorSnackbar(
              context,
              state.originalError ?? state,
              onRetry: () {
                // Re-attempt the last operation if needed
                // This would require storing the last attempted stock
              },
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: ItemForm(
              submitLabel: 'Save Item',
              onSubmit: (name, details, quantity, expirationDate) async {
                DateTime? expiration;
                if (expirationDate.isNotEmpty) {
                  try {
                    expiration = DateTime.parse(expirationDate);
                  } catch (e) {
                    InventoryErrorHandler.showErrorSnackbar(
                      context,
                      Exception('Invalid date format. Use YYYY-MM-DD'),
                    );
                    return;
                  }
                }

                if (name.trim().isEmpty) {
                  InventoryErrorHandler.showErrorSnackbar(
                    context,
                    Exception('Name cannot be empty'),
                  );
                  return;
                }

                if (quantity <= 0) {
                  InventoryErrorHandler.showErrorSnackbar(
                    context,
                    Exception('Quantity must be greater than zero'),
                  );
                  return;
                }

                final stock = StockEntity(
                  id: 0, // Will be assigned by backend
                  brand: details.isNotEmpty ? details : name,
                  quantity: quantity,
                  status: Status.UNKNOWN,
                  expirationDate: expiration,
                );

                try {
                  await context.read<InventoryCubit>().addStock(
                    safeInventoryId,
                    productId,
                    stock,
                  );
                } catch (error) {
                  // Error is already handled by the listener
                  // This catch prevents unhandled exceptions
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
