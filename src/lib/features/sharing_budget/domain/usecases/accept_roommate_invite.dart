import '../entities/enums.dart';
import '../entities/household_member_entity.dart';
import '../entities/invite_entity.dart';
import '../repositories/sharing_repository.dart';

/// Result returned after accepting a roommate invitation.
class AcceptRoommateInviteResult {
  final InviteEntity invite;
  final HouseholdMemberEntity member;

  const AcceptRoommateInviteResult({
    required this.invite,
    required this.member,
  });
}

/// Use case for accepting a roommate invitation.
///
/// Validates the invitation, prevents duplicate household membership,
/// updates the invite status, and creates the household member.
class AcceptRoommateInvite {
  final SharingRepository repository;

  const AcceptRoommateInvite(this.repository);

  Future<AcceptRoommateInviteResult> call({
    required int inviteId,
    required int userId,
    MemberRole role = MemberRole.viewer,
  }) async {
    if (inviteId <= 0) {
      throw Exception('Invite ID must be a positive number');
    }

    if (userId <= 0) {
      throw Exception('User ID must be a positive number');
    }

    final invite = await repository.getInviteById(inviteId);

    if (invite == null) {
      throw Exception('Invite was not found');
    }

    if (invite.status != InviteStatus.pending) {
      throw Exception('Only pending invites can be accepted');
    }

    if (invite.expiresAt.isBefore(DateTime.now())) {
      throw Exception('Invite has expired');
    }

    final existingMembers = await repository.getMembersByHousehold(
      invite.householdId,
    );

    final alreadyMember = existingMembers
        .whereType<HouseholdMemberEntity>()
        .any((member) => member.userId == userId);

    if (alreadyMember) {
      throw Exception('User is already a member of this household');
    }

    final updatedInvite = await repository.updateInviteStatus(
      inviteId,
      InviteStatus.accepted,
    );

    final createdMember = await repository.addMember(
      HouseholdMemberEntity(
        id: -1,
        householdId: invite.householdId,
        userId: userId,
        role: role,
      ),
    );

    return AcceptRoommateInviteResult(
      invite: updatedInvite,
      member: createdMember,
    );
  }
}
