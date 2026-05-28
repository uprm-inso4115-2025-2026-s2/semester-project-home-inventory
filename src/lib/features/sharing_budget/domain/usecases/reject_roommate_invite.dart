import '../entities/enums.dart';
import '../entities/invite_entity.dart';
import '../repositories/sharing_repository.dart';

/// Use case for rejecting a roommate invitation.
class RejectRoommateInvite {
  final SharingRepository repository;

  const RejectRoommateInvite(this.repository);

  Future<InviteEntity> call(int inviteId) async {
    if (inviteId <= 0) {
      throw Exception('Invite ID must be a positive number');
    }

    final invite = await repository.getInviteById(inviteId);

    if (invite == null) {
      throw Exception('Invite was not found');
    }

    if (invite.status != InviteStatus.pending) {
      throw Exception('Only pending invites can be rejected');
    }

    return repository.updateInviteStatus(inviteId, InviteStatus.rejected);
  }
}
