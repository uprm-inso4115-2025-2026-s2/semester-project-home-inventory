import '../../domain/entities/household_entity.dart';
import '../../domain/entities/household_member_entity.dart';

abstract class HouseholdState {
  const HouseholdState();
}

class HouseholdInitial extends HouseholdState {
  const HouseholdInitial();
}

class HouseholdLoading extends HouseholdState {
  const HouseholdLoading();
}

class HouseholdLoaded extends HouseholdState {
  final HouseholdEntity household;

  const HouseholdLoaded(this.household);
}

class HouseholdMembersLoaded extends HouseholdState {
  final List<HouseholdMemberEntity> members;

  const HouseholdMembersLoaded(this.members);
}

class HouseholdEmpty extends HouseholdState {
  final String message;

  const HouseholdEmpty(this.message);
}

class HouseholdMembershipValidated extends HouseholdState {
  final bool isValidMember;

  const HouseholdMembershipValidated(this.isValidMember);
}

class HouseholdActionSuccess extends HouseholdState {
  final String message;

  const HouseholdActionSuccess(this.message);
}

class HouseholdFailure extends HouseholdState {
  final String errorMessage;

  const HouseholdFailure(this.errorMessage);
}