import '../entities/dashboard_metrics.dart';
import '../entities/item.dart';

abstract class DashboardRepository {
  Future<DashboardMetrics> fetchMetrics();

  Future<List<Item>> fetchAllItems();

  Future<List<Item>> fetchFilteredItems({
    String? category,
    String? room,
    DateTime? startDate,
    DateTime? endDate,
  });
}
