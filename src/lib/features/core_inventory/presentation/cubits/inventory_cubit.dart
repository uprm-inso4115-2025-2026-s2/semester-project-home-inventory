import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_inventory_items.dart';
import '../../domain/usecases/get_inventory_items_by_identifier.dart';
import '../../domain/usecases/add_inventory_item.dart';
import '../../domain/usecases/update_inventory_item.dart';
import '../../domain/usecases/delete_inventory_item.dart';
import '../../domain/entities/stock.dart';
import 'inventory_state.dart';
import '../utils/error_handler.dart';  // Add this import

class InventoryCubit extends Cubit<InventoryState> {
  final GetInventoryItems _getInventoryItems;
  final GetInventoryItemsByIdentifier _getInventoryItemsByIdentifier;
  final AddInventoryItem _addInventoryItem;
  final UpdateInventoryItem _updateInventoryItem;
  final DeleteInventoryItem _deleteInventoryItem;

  int? _currentOwnerId;
  String? _currentOwnerIdentifier;

  InventoryCubit({
    required GetInventoryItems getInventoryItems,
    required GetInventoryItemsByIdentifier getInventoryItemsByIdentifier,
    required AddInventoryItem addInventoryItem,
    required UpdateInventoryItem updateInventoryItem,
    required DeleteInventoryItem deleteInventoryItem,
  }) : _getInventoryItems = getInventoryItems,
       _getInventoryItemsByIdentifier = getInventoryItemsByIdentifier,
       _addInventoryItem = addInventoryItem,
       _updateInventoryItem = updateInventoryItem,
       _deleteInventoryItem = deleteInventoryItem,
       super(InventoryInitial());

  /// Fetches the inventory for a given owner.
  Future<void> loadInventory(int ownerId) async {
    _currentOwnerId = ownerId;
    _currentOwnerIdentifier = null;
    emit(InventoryLoading());
    try {
      final inventory = await _getInventoryItems(ownerId);
      emit(InventoryLoaded(inventory));
    } catch (error) {
      // Convert to user-friendly error state
      final friendlyError = InventoryErrorHandler.getUserFriendlyMessage(error);
      emit(InventoryError(
        message: friendlyError.message,
        title: friendlyError.title,
        action: friendlyError.action,
        errorType: friendlyError.type,
        originalError: error,
      ));
    }
  }

  /// Attempts to load inventory using an owner identifier (e.g., auth UUID).
  Future<void> loadInventoryByAuthId(String ownerIdentifier) async {
    // Try parse numeric first
    final numeric = int.tryParse(ownerIdentifier);
    if (numeric != null && numeric > 0) {
      await loadInventory(numeric);
      return;
    }

    emit(InventoryLoading());
    try {
      _currentOwnerIdentifier = ownerIdentifier;
      _currentOwnerId = null;
      final inventory = await _getInventoryItemsByIdentifier(ownerIdentifier);
      emit(InventoryLoaded(inventory));
    } catch (error) {
      final friendlyError = InventoryErrorHandler.getUserFriendlyMessage(error);
      emit(InventoryError(
        message: friendlyError.message,
        title: friendlyError.title,
        action: friendlyError.action,
        errorType: friendlyError.type,
        originalError: error,
      ));
    }
  }

  /// Adds a new stock item and refreshes the inventory.
  Future<void> addStock(
    int inventoryId,
    int productId,
    StockEntity stock,
  ) async {
    if (_currentOwnerId == null && _currentOwnerIdentifier == null) {
      final error = InventoryErrorHandler.getUserFriendlyMessage(
        'No owner ID available',
      );
      emit(InventoryError(
        message: error.message,
        title: error.title,
        action: error.action,
        errorType: error.type,
      ));
      return;
    }
    
    emit(InventoryLoading());
    try {
      await _addInventoryItem(inventoryId, productId, stock);
      if (_currentOwnerId != null) {
        await loadInventory(_currentOwnerId!);
      } else if (_currentOwnerIdentifier != null) {
        await loadInventoryByAuthId(_currentOwnerIdentifier!);
      }
    } catch (error) {
      final friendlyError = InventoryErrorHandler.getUserFriendlyMessage(error);
      emit(InventoryError(
        message: friendlyError.message,
        title: friendlyError.title,
        action: friendlyError.action,
        errorType: friendlyError.type,
        originalError: error,
      ));
      // Re-throw for snackbar display in UI
      rethrow;
    }
  }

  /// Updates an existing stock item and refreshes the inventory.
  Future<void> updateStock(
    int inventoryId,
    int productId,
    StockEntity stock,
  ) async {
    if (_currentOwnerId == null && _currentOwnerIdentifier == null) {
      final error = InventoryErrorHandler.getUserFriendlyMessage(
        'No owner ID available',
      );
      emit(InventoryError(
        message: error.message,
        title: error.title,
        action: error.action,
        errorType: error.type,
      ));
      return;
    }
    
    emit(InventoryLoading());
    try {
      await _updateInventoryItem(inventoryId, productId, stock);
      if (_currentOwnerId != null) {
        await loadInventory(_currentOwnerId!);
      } else if (_currentOwnerIdentifier != null) {
        await loadInventoryByAuthId(_currentOwnerIdentifier!);
      }
    } catch (error) {
      final friendlyError = InventoryErrorHandler.getUserFriendlyMessage(error);
      emit(InventoryError(
        message: friendlyError.message,
        title: friendlyError.title,
        action: friendlyError.action,
        errorType: friendlyError.type,
        originalError: error,
      ));
      rethrow;
    }
  }

  /// Deletes a stock item and refreshes the inventory.
  Future<void> deleteStock(int inventoryId, int productId, int stockId) async {
    if (_currentOwnerId == null && _currentOwnerIdentifier == null) {
      final error = InventoryErrorHandler.getUserFriendlyMessage(
        'No owner ID available',
      );
      emit(InventoryError(
        message: error.message,
        title: error.title,
        action: error.action,
        errorType: error.type,
      ));
      return;
    }
    
    emit(InventoryLoading());
    try {
      await _deleteInventoryItem(inventoryId, productId, stockId);
      if (_currentOwnerId != null) {
        await loadInventory(_currentOwnerId!);
      } else if (_currentOwnerIdentifier != null) {
        await loadInventoryByAuthId(_currentOwnerIdentifier!);
      }
    } catch (error) {
      final friendlyError = InventoryErrorHandler.getUserFriendlyMessage(error);
      emit(InventoryError(
        message: friendlyError.message,
        title: friendlyError.title,
        action: friendlyError.action,
        errorType: friendlyError.type,
        originalError: error,
      ));
      rethrow;
    }
  }
  
  /// Retry the last failed operation
  Future<void> retryLastOperation() async {
    if (_currentOwnerId != null) {
      await loadInventory(_currentOwnerId!);
    } else if (_currentOwnerIdentifier != null) {
      await loadInventoryByAuthId(_currentOwnerIdentifier!);
    }
  }
}
