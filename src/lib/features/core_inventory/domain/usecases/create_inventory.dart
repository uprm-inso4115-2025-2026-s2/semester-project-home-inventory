import '../entities/inventory.dart';
import '../repositories/inventory_repositories.dart';

//use case to create a new inventory for an owner

class CreateInventory {
  final InventoryRepository _repository;

  CreateInventory(this._repository);

  //[inventory] is the inventory entity to create (must contain ownerId)
  //returns [InventoryEntity] with the created inventory

  Future<InventoryEntity> call(InventoryEntity inventory) async {
    //validation

    if (inventory.ownerId <= 0) {
      throw Exception('Owner ID must be a positive number');
    }

    return await _repository.createInventory(inventory);
  }
}
