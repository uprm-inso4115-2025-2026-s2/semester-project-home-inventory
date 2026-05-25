import '../entities/inventory_item.dart';

abstract class InventoryRepository {
  /// Fetch inventory items based on filters.
  /// 
  /// - [startDate] / [endDate] filter items by creation date.
  /// - [page] determines which category page is requested (0 or 1).
  /// - [searchQuery] filters by name, category, or status (case‑insensitive).
  Future<List<InventoryItem>> fetchItems({
    required DateTime startDate,
    required DateTime endDate,
    required int page,
    required String searchQuery,
  });
}