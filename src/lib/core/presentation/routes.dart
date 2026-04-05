import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/core/presentation/pages/main_nav_shell.dart';
import 'package:src/core/presentation/pages/home_dashboard_page.dart';
import 'package:src/features/core_inventory/presentation/routes.dart';
import 'package:src/features/grocery_list/presentation/routes.dart';
import 'package:src/features/reports/presentation/routes.dart';
// TO DO: route InviteRoommatePage properly
import 'package:src/features/invite_roomate_page/presentation/routes.dart';

const List<MainNavTab> _mainTabs = [
  MainNavTab(label: 'Home', icon: Icons.home_filled, rootPath: '/home'),
  MainNavTab(
    label: 'Grocery',
    icon: Icons.checklist,
    rootPath: '/grocery_home',
  ),
  // Replaced /add-item route with the Add Item page in the Inventory section,
  // since wireframes establish that as the proposed navigation.
  MainNavTab(label: 'Inventory', icon: Icons.inventory, rootPath: '/inventory'),
  MainNavTab(
    label: 'Reports',
    icon: Icons.bar_chart,
    rootPath: '/home/reports',
  ),
  MainNavTab(label: 'Alerts', icon: Icons.notifications, rootPath: '/alerts'),
];

// Placeholder page for the AlertsPage
class _AlertsPageStub extends StatelessWidget {
  const _AlertsPageStub();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('TO DO: Route Alerts screen')),
    );
  }
}

var mainRoutes = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return MainNavShell(navigationShell: navigationShell, tabs: _mainTabs);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeDashboardPage()),
      ],
    ),
    StatefulShellBranch(routes: [groceryListRoutes]),
    // Replaced /add-item route with the Add Item page in the Inventory section,
    // since wireframes establish that as the proposed navigation.
    StatefulShellBranch(routes: [inventoryRoutes]),
    StatefulShellBranch(routes: [reportsOverviewRoute]),
    StatefulShellBranch(
      routes: [
        GoRoute(path: '/alerts', builder: (_, __) => const _AlertsPageStub()),
      ],
    ),
  ],
);
