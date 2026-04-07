import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../config/injection_dependencies.dart';
import '../../example_feature/presentation/cubits/todo_cubit.dart';
import 'pages/alerts_home.dart';

var alertsFeedRoutes = GoRoute(
  path: '/alerts_home',
  builder: (_, __) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: sl<TodoCubit>())],
      child: AlertsHome(),
    );
  },
);
