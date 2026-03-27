import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/features/reports/presentation/pages/reports_overview_page.dart';
import 'package:src/features/reports/presentation/pages/inventory_stock_report_page.dart';

//STUB PAGES-----------------------------------------------------
//TO DO: Replace each stub with the real page once implemented.

class _ItemUsageRatesStubPage extends StatelessWidget {
  const _ItemUsageRatesStubPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item Usage Rates')),
      body: const Center(child: Text('TO DO: Implement Item Usage Rates screen')),
    );
  }
}

class _ExpendituresStubPage extends StatelessWidget {
  const _ExpendituresStubPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expenditures')),
      body: const Center(child: Text('TO DO: Implement Expenditures screen')),
    );
  }
}
//-----------------------------------------------------------

//Route definitions

var reportsOverviewRoute = GoRoute(
  path: 'reports',
  name: 'reports_overview',
  builder: (context, state) => const ReportsOverviewPage(),
  routes: [
    GoRoute(
      path: 'inventory-stock-summary',
      name: 'inventory_stock_report',
      builder: (context, state) => const InventoryStockReportPage(),
    ),
    GoRoute(
      path: 'item-usage-rates',
      name: 'item_usage_rates',
//TO DO: Replace stub with real ItemUsageRatesPage once implemented
      builder: (context, state) => const _ItemUsageRatesStubPage(),
    ),
    GoRoute(
      path: 'expenditures',
      name: 'expenditures',
//TO DO: Replace stub with real ExpendituresPage once implemented
      builder: (context, state) => const _ExpendituresStubPage(),
    ),
  ],
);