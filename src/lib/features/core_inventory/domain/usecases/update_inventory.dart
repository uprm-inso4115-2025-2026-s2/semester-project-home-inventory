import '../entities/inventory.dart';
import '../repositories/inventory_repositories.dart';

//use case to update an existing inventory

class UpdateInventory {
  final InventoryRepository _repository;

  UpdateInventory(this._repository);

  //[inventory] is the updated inventory entity
  //returns [InventoryEntity] with the updated inventory

  Future<InventoryEntity> call(InventoryEntity inventory) async {
    //validations

    if (inventory.id <= 0) {
      throw Exception('Inventory ID must be a positive number');
    }

    if (inventory.ownerId <= 0) {
      throw Exception('Owner ID must be a positive number');
    }

    return await _repository.updateInventory(inventory);
  }
}
