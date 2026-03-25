import 'package:go_router/go_router.dart';
import 'package:src/features/reports/presentation/pages/inventory_stock_report_page.dart';
//only for testing purposes
import 'package:src/features/reports/presentation/pages/report_list_page_not_official.dart';

var inventoryStockReportRoute = GoRoute(
  path: 'inventory-stock-summary',
  name: 'inventory_stock_report',
  builder: (context, state) => const InventoryStockReportPage(),
);

var reportListRoute = GoRoute(
  path: 'reports',
  name: 'reports_list',
  builder: (context, state) => const ReportListPage(),
);