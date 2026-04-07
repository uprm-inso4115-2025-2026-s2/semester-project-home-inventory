import '../domain/repositories/dashboard_repositories.dart';
import '../domain/entities/item.dart';
import '../domain/entities/dashboard_metrics.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<List<Item>> fetchAllItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Item(
        id: '1',
        name: 'TV',
        category: 'Electronics',
        room: 'Living Room',
        value: 500.0,
        createdAt: DateTime.now(),
      ),
      Item(
        id: '2',
        name: 'Sofa',
        category: 'Furniture',
        room: 'Living Room',
        value: 800.0,
        createdAt: DateTime.now(),
      ),
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
      Item(
        id: '1',
        name: 'TV',
        category: 'Electronics',
        room: 'Living Room',
        value: 500.0,
        createdAt: DateTime.now(),
      ),
      Item(
        id: '2',
        name: 'Sofa',
        category: 'Furniture',
        room: 'Living Room',
        value: 800.0,
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<DashboardMetrics> fetchMetrics() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DashboardMetrics();
  }
}
