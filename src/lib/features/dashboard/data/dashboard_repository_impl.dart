import '../domain/repositories/dashboard_repositories.dart';
import '../domain/entities/item.dart';
import '../domain/entities/dashboard_metrics.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<List<Item>> fetchAllItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Item(),
      Item(),
      Item(),
    ];
  }

  @override
  Future<List<Item>> fetchFilteredItems({
    String? category,
    String? room,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Item(),
    ];
  }

  @override
  Future<DashboardMetrics> fetchMetrics() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DashboardMetrics();
  }
}