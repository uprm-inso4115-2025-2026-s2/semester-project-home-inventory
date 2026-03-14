import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:src/features/example_feature/presentation/cubits/todo_cubit.dart';
import 'package:src/features/grocery_list/presentation/pages/add_item.dart';
import 'package:src/features/grocery_list/presentation/pages/categories.dart';
import 'package:src/features/grocery_list/presentation/pages/custom_items.dart';
import 'package:src/features/grocery_list/presentation/pages/history.dart';
import 'package:src/features/grocery_list/presentation/pages/home_page.dart';

import '../../../config/injection_dependencies.dart';

var groceryListRoutes = GoRoute(
  path: '/grocery_home',
  builder: (_, __) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: sl<TodoCubit>())],
      child: HomePage(),
    );
  },
  routes: [
    GoRoute(
      path: "categories",
      builder: (_, __) {
        return Categories();
      },
      routes: [
        GoRoute(
          path: "custom_items",
          builder: (_, __) {
            return CustomItems();
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
        return AddItem();
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
