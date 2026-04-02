import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_inventory_items.dart';
import '../../domain/usecases/add_inventory_item.dart';
import '../../domain/usecases/update_inventory_item.dart';
import '../../domain/usecases/delete_inventory_item.dart';
import '../../domain/entities/stock.dart';
import 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final GetInventoryItems _getInventoryItems;
  final AddInventoryItem _addInventoryItem;
  final UpdateInventoryItem _updateInventoryItem;
  final DeleteInventoryItem _deleteInventoryItem;

  int? _currentOwnerId;

  InventoryCubit({
    required GetInventoryItems getInventoryItems,
    required AddInventoryItem addInventoryItem,
    required UpdateInventoryItem updateInventoryItem,
    required DeleteInventoryItem deleteInventoryItem,
  })  : _getInventoryItems = getInventoryItems,
        _addInventoryItem = addInventoryItem,
        _updateInventoryItem = updateInventoryItem,
        _deleteInventoryItem = deleteInventoryItem,
        super(InventoryInitial());

  /// Fetches the inventory for a given owner.
  Future<void> loadInventory(int ownerId) async {
    _currentOwnerId = ownerId;
    emit(InventoryLoading());
    try {
      final inventory = await _getInventoryItems(ownerId);
      emit(InventoryLoaded(inventory));
    } catch (error) {
      emit(InventoryError(error.toString()));
    }
  }

  /// Adds a new stock item and refreshes the inventory.
  Future<void> addStock(int inventoryId, int productId, StockEntity stock) async {
    if (_currentOwnerId == null) {
      emit(const InventoryError("Cannot add stock: Owner ID is unknown."));
      return;
    }
    emit(InventoryLoading());
    try {
      await _addInventoryItem(inventoryId, productId, stock);
      await loadInventory(_currentOwnerId!); // Refresh data
    } catch (error) {
      emit(InventoryError(error.toString()));
    }
  }

  /// Updates an existing stock item and refreshes the inventory.
  Future<void> updateStock(int inventoryId, int productId, StockEntity stock) async {
    if (_currentOwnerId == null) {
      emit(const InventoryError("Cannot update stock: Owner ID is unknown."));
      return;
    }
    emit(InventoryLoading());
    try {
      await _updateInventoryItem(inventoryId, productId, stock);
      await loadInventory(_currentOwnerId!); // Refresh data
    } catch (error) {
      emit(InventoryError(error.toString()));
    }
  }

  /// Deletes a stock item and refreshes the inventory.
  Future<void> deleteStock(int inventoryId, int productId, int stockId) async {
    if (_currentOwnerId == null) {
      emit(const InventoryError("Cannot delete stock: Owner ID is unknown."));
      return;
    }
    emit(InventoryLoading());
    try {
      await _deleteInventoryItem(inventoryId, productId, stockId);
      await loadInventory(_currentOwnerId!); // Refresh data
    } catch (error) {
      emit(InventoryError(error.toString()));
    }
  }
}