import 'package:go_router/go_router.dart';
import 'package:src/features/example_feature/presentation/pages/todos_page.dart';

var todosRoutes = GoRoute(
  path: '/todos',
  builder: (_, __) {
    return TodosPage();
  },
);
