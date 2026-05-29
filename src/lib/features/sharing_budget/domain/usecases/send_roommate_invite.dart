import '../entities/enums.dart';
import '../entities/invite_entity.dart';
import '../repositories/sharing_repository.dart';

/// Use case for sending a roommate invitation.
///
/// Includes duplicate prevention for active pending invitations
/// sent to the same email within the same household.
class SendRoommateInvite {
  final SharingRepository repository;

  const SendRoommateInvite(this.repository);

  Future<InviteEntity> call(InviteEntity invite) async {
    if (invite.householdId <= 0) {
      throw Exception('Household ID must be a positive number');
    }

    if (invite.invitedByUserId <= 0) {
      throw Exception('Inviting user ID must be a positive number');
    }

    if (invite.invitedEmail.trim().isEmpty) {
      throw Exception('Invited email cannot be empty');
    }

    if (!invite.invitedEmail.contains('@')) {
      throw Exception('Invited email must be valid');
    }

    if (!invite.expiresAt.isAfter(invite.createdAt)) {
      throw Exception('Invite expiration date must be after creation date');
    }

    final existingInvites = await repository.getInvitesByHousehold(
      invite.householdId,
    );

    final normalizedEmail = invite.invitedEmail.trim().toLowerCase();
    final now = DateTime.now();

    final duplicatePendingInvite = existingInvites
        .whereType<InviteEntity>()
        .any((existingInvite) {
          return existingInvite.invitedEmail.trim().toLowerCase() ==
                  normalizedEmail &&
              existingInvite.status == InviteStatus.pending &&
              existingInvite.expiresAt.isAfter(now);
        });

    if (duplicatePendingInvite) {
      throw Exception('A pending invite already exists for this email');
    }

    return repository.sendInvite(invite);
  }
}
