import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:src/features/grocery_list/data/constants.dart';
import 'package:src/features/grocery_list/presentation/cubits/grocery_list_cubit.dart';
import 'package:src/features/grocery_list/presentation/pages/add_item.dart';
import 'package:src/features/grocery_list/presentation/pages/categories.dart';
import 'package:src/features/grocery_list/presentation/pages/custom_items.dart';
import 'package:src/features/grocery_list/presentation/pages/history.dart';
import 'package:src/features/grocery_list/presentation/pages/home_page.dart';

import '../../../config/injection_dependencies.dart';

var groceryListRoutes = GoRoute(
  path: '/grocery_home',
  builder: (_, __) {
    return BlocProvider.value(
      value: sl<GroceryListCubit>(),
      child: const HomePage(),
    );
  },
  routes: [
    GoRoute(
      path: "categories/:collectionName",
      builder: (context, state) {
        final collectionName = Uri.decodeComponent(
          state.pathParameters['collectionName'] ?? collectionNames.first,
        );
        return BlocProvider.value(
          value: sl<GroceryListCubit>(),
          child: Categories(
            collectionName: collectionName,
          ),
        );
      },
      routes: [
        GoRoute(
          path: "custom_items",
          builder: (_, __) {
            return BlocProvider.value(
              value: sl<GroceryListCubit>(),
              child: const CustomItems(),
            );
          },
          routes: [
            GoRoute(
              path: "edit_item",
              builder: (_, __) {
                return AddItem(isCustom: true);
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: "add_item",
      builder: (_, __) {
        return BlocProvider.value(
          value: sl<GroceryListCubit>(),
          child: const AddItem(),
        );
      },
    ),
    GoRoute(
      path: "history",
      builder: (_, __) {
        return History();
      },
    ),
  ],
);
