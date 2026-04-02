import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/features/core_inventory/presentation/cubits/edit_item_cubit.dart';
import 'package:src/features/core_inventory/presentation/cubits/inventory_category_cubit.dart';
import 'package:src/features/core_inventory/presentation/pages/add_item_page.dart';
import 'package:src/features/core_inventory/presentation/pages/edit_item_page.dart';
import 'package:src/features/core_inventory/presentation/pages/inventory_category_page.dart';
import 'package:src/features/core_inventory/presentation/pages/inventory_page.dart';
import 'package:src/features/core_inventory/presentation/pages/item_labels_page.dart';

var inventoryRoutes = GoRoute(
  path: 'inventory',
  name: 'inventory_home',
  builder: (context, state) => const InventoryPage(),
  routes: [
    GoRoute(
      path: 'category/:categoryId',
      name: 'inventory_category',
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId']!;
        return BlocProvider(
          create: (_) => InventoryCategoryCubit(categoryId),
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
          path: 'add',
          name: 'inventory_add_item',
          builder: (context, state) => const AddItemPage(),
        ),
        GoRoute(
          path: 'edit/:itemId',
          name: 'inventory_edit_item',
          builder: (context, state) {
            final itemId = int.tryParse(state.pathParameters['itemId']!) ?? 0;
            return BlocProvider(
              create: (_) => EditItemCubit(itemId),
              child: const EditItemPage(),
            );
          },
        ),
      ],
    ),
  ],
);
