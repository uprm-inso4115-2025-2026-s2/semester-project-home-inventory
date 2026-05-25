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

class EditItemPage extends StatelessWidget {
  const EditItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Extract IDs from route
    final productId =
        int.tryParse(
          GoRouterState.of(context).pathParameters['productId'] ?? '0',
        ) ??
        0;

    final stockId =
        int.tryParse(
          GoRouterState.of(context).pathParameters['stockId'] ?? '0',
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

    // Get current stock from cubit state to pre-fill form
    return BlocBuilder<InventoryCubit, InventoryState>(
      builder: (context, state) {
        StockEntity currentStock = const StockEntity(
          id: 0,
          brand: 'Generic',
          quantity: 1,
          status: Status.UNKNOWN,
        );

        // Try to find current stock from loaded inventory
        if (state is InventoryLoaded) {
          final inventory = state.inventory;
          for (final stocks in inventory.stock.values) {
            final found = stocks.firstWhere(
              (stock) => stock.id == stockId,
              orElse: () => currentStock,
            );
            if (found.id != 0) {
              currentStock = found;
              break;
            }
          }
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Edit Item')),
          body: BlocListener<InventoryCubit, InventoryState>(
            listener: (context, state) {
              if (state is InventoryLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item updated successfully')),
                );
                context.pop();
              } else if (state is InventoryError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              }
            },
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                child: ItemForm(
                  submitLabel: 'Update Item',
                  initialName: currentStock.brand,
                  initialDetails: currentStock.brand,
                  initialQuantity: currentStock.quantity,
                  initialExpirationDate: _formatDate(
                    currentStock.expirationDate,
                  ),
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

                    // Create updated stock entity
                    final updatedStock = StockEntity(
                      id: stockId,
                      brand: details.isNotEmpty ? details : 'Generic',
                      quantity: quantity,
                      status: currentStock.status,
                      expirationDate: expiration,
                    );

                    context.read<InventoryCubit>().updateStock(
                      safeInventoryId,
                      productId,
                      updatedStock,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
