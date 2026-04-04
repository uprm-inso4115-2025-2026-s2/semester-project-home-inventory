import 'package:go_router/go_router.dart';
import 'package:src/core/presentation/pages/home_page.dart';
import 'package:src/features/example_feature/presentation/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:src/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:src/features/dashboard/data/dashboard_repository_impl.dart';

var mainRoutes = GoRoute(
  path: '/home',
  builder: (_, __) {
    return HomePage();
  },
  routes: [
    todosRoutes,

    GoRoute(
      path: 'dashboard',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => DashboardCubit(
            // Temporary placeholder
            DashboardRepositoryImpl(),
          )..fetchInitialData(),
          child: const DashboardPage(),
        );
      },
    ),
  ],
);
