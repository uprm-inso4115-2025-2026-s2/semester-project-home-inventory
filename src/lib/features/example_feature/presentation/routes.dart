import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:src/features/example_feature/presentation/cubits/todo_cubit.dart';
import 'package:src/features/example_feature/presentation/pages/todos_page.dart';

import '../../../config/injection_dependencies.dart';

var todosRoutes = GoRoute(
  path: '/todos',
  builder: (_, __) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: sl<TodoCubit>())],
      child: TodosPage(),
    );
  },
  routes: [],
);
