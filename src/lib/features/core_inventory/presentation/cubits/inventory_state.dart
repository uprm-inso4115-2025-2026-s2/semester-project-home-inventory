import 'package:equatable/equatable.dart';
import '../../domain/entities/inventory.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object?> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final InventoryEntity inventory;
  const InventoryLoaded(this.inventory);

  @override
  List<Object?> get props => [inventory];
}

class InventoryError extends InventoryState {
  final String message;
  const InventoryError(this.message);

  @override
  List<Object?> get props => [message];
}
