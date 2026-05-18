import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:src/config/injection_dependencies.dart';
import 'package:src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:src/features/auth/presentation/cubit/auth_state.dart';
import 'package:src/features/core_inventory/presentation/cubits/inventory_cubit.dart';
import 'package:src/features/core_inventory/presentation/cubits/product_stock_cubit.dart';
import 'package:src/features/core_inventory/presentation/pages/add_item_page.dart';
import 'package:src/features/core_inventory/presentation/pages/edit_item_page.dart';
import 'package:src/features/core_inventory/presentation/pages/inventory_category_page.dart';
import 'package:src/features/core_inventory/presentation/pages/inventory_page.dart';
import 'package:src/features/core_inventory/presentation/pages/item_labels_page.dart';
import 'package:src/features/core_inventory/presentation/pages/product_stock_page.dart';

var inventoryRoutes = GoRoute(
  path: '/inventory',
  name: 'inventory_home',
  builder: (context, state) => const InventoryPage(),
  routes: [
    GoRoute(
      path: 'category/:categoryId',
      name: 'inventory_category',
      builder: (context, state) {
        // Get current user ID from AuthCubit to load their inventory
        final authState = sl<AuthCubit>().state;
        int? ownerId;

        if (authState is AuthAuthenticated) {
          ownerId = int.tryParse(authState.user.id);
        }

        // Provide InventoryCubit for this subtree. If the auth user id is
        // not a numeric id (e.g., Supabase UUID), attempt to load inventory
        // using the auth identifier via a tolerant cubit method.
        return BlocProvider<InventoryCubit>(
          create: (context) {
            final cubit = sl<InventoryCubit>();

            if (ownerId != null) {
              cubit.loadInventory(ownerId);
            } else if (authState is AuthAuthenticated) {
              // Defer loading by identifier to avoid blocking the builder.
              Future.microtask(
                () => cubit.loadInventoryByAuthId(authState.user.id),
              );
            }

            return cubit;
          },
          child: const InventoryCategoryPage(),
        );
      },
      routes: [
        GoRoute(
          path: 'labels',
          name: 'inventory_labels',
          builder: (context, state) => const ItemLabelsPage(),
        ),
        GoRoute(
          path: 'add/:productId',
          name: 'inventory_add_item',
          builder: (context, state) => const AddItemPage(),
        ),
        GoRoute(
          path: 'edit/:productId/:stockId',
          name: 'inventory_edit_item',
          builder: (context, state) => const EditItemPage(),
        ),
        GoRoute(
          path: 'product/:productId',
          name: 'inventory_product_stock',
          builder: (context, state) => BlocProvider(
            create: (_) => ProductStockCubit(),
            child: const ProductStockPage(),
          ),
        ),
      ],
    ),
  ],
);