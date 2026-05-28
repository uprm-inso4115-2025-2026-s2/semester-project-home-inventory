import 'package:src/features/sharing_budget/domain/entities/enums.dart';
import 'package:src/features/sharing_budget/domain/entities/invite_entity.dart';
import 'package:src/features/sharing_budget/domain/repositories/sharing_repository.dart';

class SendInviteUseCase {
  final SharingRepository _repository;

  SendInviteUseCase(this._repository);

  Future<InviteEntity> call(InviteEntity invite) {
    return _repository.sendInvite(invite);
  }
}

class GetInvitesByHouseholdUseCase {
  final SharingRepository _repository;

  GetInvitesByHouseholdUseCase(this._repository);

  Future<List<InviteEntity>> call(int householdId) {
    return _repository.getInvitesByHousehold(householdId);
  }
}

class RespondToInviteUseCase {
  final SharingRepository _repository;

  RespondToInviteUseCase(this._repository);

  Future<InviteEntity> call(int inviteId, InviteStatus status) {
    return _repository.updateInviteStatus(inviteId, status);
  }
}