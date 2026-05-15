import '../entities/inventory.dart';
import '../repositories/inventory_repositories.dart';

class GetInventoryItemsByIdentifier {
  final InventoryRepository repository;

  const GetInventoryItemsByIdentifier(this.repository);

  Future<InventoryEntity> call(String ownerIdentifier) {
    return repository.getInventoryByOwnerIdentifier(ownerIdentifier);
  }
}
