import '../../domain/entities/invite_entity.dart';
import '../../domain/usecases/accept_roommate_invite.dart';

abstract class InvitationState {
  const InvitationState();
}

class InvitationInitial extends InvitationState {
  const InvitationInitial();
}

class InvitationLoading extends InvitationState {
  const InvitationLoading();
}

class InvitationLoaded extends InvitationState {
  final InviteEntity invite;

  const InvitationLoaded(this.invite);
}

class HouseholdInvitesLoaded extends InvitationState {
  final List<InviteEntity> invites;

  const HouseholdInvitesLoaded(this.invites);
}

class InvitationAccepted extends InvitationState {
  final AcceptRoommateInviteResult result;

  const InvitationAccepted(this.result);
}

class InvitationRejected extends InvitationState {
  final InviteEntity invite;

  const InvitationRejected(this.invite);
}

class InvitationSent extends InvitationState {
  final InviteEntity invite;

  const InvitationSent(this.invite);
}

class InvitationEmpty extends InvitationState {
  final String message;

  const InvitationEmpty(this.message);
}

class InvitationFailure extends InvitationState {
  final String errorMessage;

  const InvitationFailure(this.errorMessage);
}