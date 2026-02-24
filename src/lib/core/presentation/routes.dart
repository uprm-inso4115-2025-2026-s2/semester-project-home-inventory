import 'package:go_router/go_router.dart';
import 'package:src/core/presentation/home_page.dart';
import 'package:src/features/example_feature/presentation/routes.dart';

var mainRoutes = GoRoute(
  path: '/home',
  builder: (_, __) {
    return HomePage();
  },
  routes: [
    todosRoutes,
  ],
);
