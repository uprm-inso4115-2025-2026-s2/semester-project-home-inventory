import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:src/core/presentation/pages/main_nav_shell.dart';
import 'package:src/core/presentation/pages/home_dashboard_page.dart';

import 'package:src/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:src/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:src/features/dashboard/data/dashboard_repository_impl.dart';

import 'package:src/features/core_inventory/presentation/routes.dart';
import 'package:src/features/grocery_list/presentation/routes.dart';
import 'package:src/features/reports/presentation/routes.dart';

const List<MainNavTab> mainTabs = [
  MainNavTab(label: 'Home', icon: Icons.home_filled, rootPath: '/home'),
  MainNavTab(label: 'Grocery', icon: Icons.checklist, rootPath: '/grocery_home'),
  MainNavTab(label: 'Inventory', icon: Icons.inventory, rootPath: '/inventory'),
  MainNavTab(label: 'Reports', icon: Icons.bar_chart, rootPath: '/home/reports'),
  MainNavTab(label: 'Alerts', icon: Icons.notifications, rootPath: '/alerts'),
];

class AlertsPageStub extends StatelessWidget {
  const AlertsPageStub({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('TO DO: Route Alerts screen'),
      ),
    );
  }
}

var mainRoutes = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return MainNavShell(
      navigationShell: navigationShell,
      tabs: mainTabs,
    );
  },

  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) {
            return const HomeDashboardPage();
          },
          routes: [
            GoRoute(
              path: 'dashboard',
              builder: (context, state) {
                return BlocProvider(
                  create: (_) =>
                      DashboardCubit(DashboardRepositoryImpl())
                        ..fetchInitialData(),
                  child: const DashboardPage(),
                );
              },
            ),
          ],
        ),
      ],
    ),

    StatefulShellBranch(
      routes: [groceryListRoutes],
    ),

    StatefulShellBranch(
      routes: [inventoryRoutes],
    ),

    StatefulShellBranch(
      routes: [reportsOverviewRoute],
    ),

    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/alerts',
          builder: (_, __) => const AlertsPageStub(),
        ),
      ],
    ),
  ],
);