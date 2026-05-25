import '../../domain/entities/inventory.dart';
import '../utils/error_handler.dart';

abstract class InventoryState {
  const InventoryState();
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final InventoryEntity inventory;
  const InventoryLoaded(this.inventory);
}

class InventoryError extends InventoryState {
  final String message;
  final String title;
  final String action;
  final ErrorType errorType;
  final dynamic originalError;
  
  const InventoryError({
    required this.message,
    required this.title,
    required this.action,
    required this.errorType,
    this.originalError,
  });
}
