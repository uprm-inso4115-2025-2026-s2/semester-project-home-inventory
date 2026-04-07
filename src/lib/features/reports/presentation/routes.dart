import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:src/features/reports/presentation/pages/reports_overview_page.dart';
import 'package:src/features/reports/presentation/pages/inventory_stock_report_page.dart';
import 'package:src/features/reports/presentation/pages/expenditure_report_page.dart';
import 'package:src/features/reports/presentation/pages/item_usage_rates_page.dart';

//Route definitions

var reportsOverviewRoute = GoRoute(
  path: '/home/reports',
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
      builder: (context, state) => const ItemUsageRatesPage(),
    ),
    GoRoute(
      path: 'expenditures',
      name: 'expenditures',
      builder: (context, state) => const ExpenditureReportPage(),
    ),
  ],
);