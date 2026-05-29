import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/invite_entity.dart';
import '../../domain/usecases/accept_roommate_invite.dart';
import '../../domain/usecases/get_household_invites.dart';
import '../../domain/usecases/get_invite_by_id.dart';
import '../../domain/usecases/reject_roommate_invite.dart';
import '../../domain/usecases/send_roommate_invite.dart';
import 'invitation_state.dart';

class InvitationCubit extends Cubit<InvitationState> {
  final SendRoommateInvite _sendRoommateInvite;
  final GetInviteById _getInviteById;
  final GetHouseholdInvites _getHouseholdInvites;
  final AcceptRoommateInvite _acceptRoommateInvite;
  final RejectRoommateInvite _rejectRoommateInvite;

  int? _currentHouseholdId;

  InvitationCubit({
    required SendRoommateInvite sendRoommateInvite,
    required GetInviteById getInviteById,
    required GetHouseholdInvites getHouseholdInvites,
    required AcceptRoommateInvite acceptRoommateInvite,
    required RejectRoommateInvite rejectRoommateInvite,
  }) : _sendRoommateInvite = sendRoommateInvite,
       _getInviteById = getInviteById,
       _getHouseholdInvites = getHouseholdInvites,
       _acceptRoommateInvite = acceptRoommateInvite,
       _rejectRoommateInvite = rejectRoommateInvite,
       super(const InvitationInitial());

  Future<void> sendInvite(InviteEntity invite) async {
    emit(const InvitationLoading());

    try {
      final sentInvite = await _sendRoommateInvite(invite);
      _currentHouseholdId = sentInvite.householdId;
      emit(InvitationSent(sentInvite));
    } catch (error) {
      emit(InvitationFailure(error.toString()));
    }
  }

  Future<void> loadInvite(int inviteId) async {
    emit(const InvitationLoading());

    try {
      final invite = await _getInviteById(inviteId);

      if (invite == null) {
        emit(const InvitationEmpty('Invitation was not found'));
        return;
      }

      _currentHouseholdId = invite.householdId;
      emit(InvitationLoaded(invite));
    } catch (error) {
      emit(InvitationFailure(error.toString()));
    }
  }

  Future<void> loadHouseholdInvites(int householdId) async {
    emit(const InvitationLoading());

    try {
      _currentHouseholdId = householdId;
      final invites = await _getHouseholdInvites(householdId);

      if (invites.isEmpty) {
        emit(const InvitationEmpty('No invitations found'));
        return;
      }

      emit(HouseholdInvitesLoaded(invites));
    } catch (error) {
      emit(InvitationFailure(error.toString()));
    }
  }

  Future<void> acceptInvite({
    required int inviteId,
    required int userId,
    MemberRole role = MemberRole.viewer,
  }) async {
    emit(const InvitationLoading());

    try {
      final result = await _acceptRoommateInvite(
        inviteId: inviteId,
        userId: userId,
        role: role,
      );

      _currentHouseholdId = result.invite.householdId;
      emit(InvitationAccepted(result));
    } catch (error) {
      emit(InvitationFailure(error.toString()));
    }
  }

  Future<void> rejectInvite(int inviteId) async {
    emit(const InvitationLoading());

    try {
      final rejectedInvite = await _rejectRoommateInvite(inviteId);
      _currentHouseholdId = rejectedInvite.householdId;
      emit(InvitationRejected(rejectedInvite));
    } catch (error) {
      emit(InvitationFailure(error.toString()));
    }
  }

  Future<void> refreshCurrentHouseholdInvites() async {
    if (_currentHouseholdId == null) {
      emit(const InvitationFailure('No household selected'));
      return;
    }

    await loadHouseholdInvites(_currentHouseholdId!);
  }

  void reset() {
    _currentHouseholdId = null;
    emit(const InvitationInitial());
  }
}