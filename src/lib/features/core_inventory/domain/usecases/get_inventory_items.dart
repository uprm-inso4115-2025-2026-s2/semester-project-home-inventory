
import '../entities/inventory.dart';
import '../repositories/inventory_repositories.dart';

//use to case to retrieve inventory items by owner ID

class GetInventoryItems{
  final InventoryRepository _repository;

  GetInventoryItems(this._repository);

  //[ownerId] is the ID of the owner of the inventory to retrieve

  //returns [InventoryEntity] that contains the owner's inventory

  //throws exception if validation fails or inventory not found 

  Future<InventoryEntity> call(int ownerId) async{

    //validation
    if(ownerId <= 0){
      throw Exception('Owner ID must be positive number');
    }

    return await _repository.getInventoryByOwnerId(ownerId);
  }
}
