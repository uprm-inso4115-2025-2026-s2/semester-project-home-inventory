import '../entities/invite_entity.dart';
import '../repositories/sharing_repository.dart';

/// Use case for retrieving an invitation by ID.
class GetInviteById {
  final SharingRepository repository;

  const GetInviteById(this.repository);

  Future<InviteEntity?> call(int inviteId) async {
    if (inviteId <= 0) {
      throw Exception('Invite ID must be a positive number');
    }

    return repository.getInviteById(inviteId);
  }
}
