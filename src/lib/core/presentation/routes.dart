import 'package:go_router/go_router.dart';
import 'package:src/core/presentation/pages/home_page.dart';
import 'package:src/features/example_feature/presentation/routes.dart';
import 'package:src/features/grocery_list/presentation/routes.dart';
import 'package:src/features/reports/presentation/routes.dart';

var mainRoutes = GoRoute(
  path: '/home',
  builder: (_, __) {
    return HomePage();
  },
  routes: [
    todosRoutes,
    inventoryStockReportRoute,
    groceryListRoutes
  ],
);
