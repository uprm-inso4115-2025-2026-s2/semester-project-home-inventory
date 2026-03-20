import 'package:go_router/go_router.dart';
import 'package:src/features/reports/presentation/pages/inventory_stock_report_page.dart';

var inventoryStockReportRoute = GoRoute(
  path: 'inventory-stock-summary',
  name: 'inventory_stock_report',
  builder: (context, state) => const InventoryStockReportPage(),
);
