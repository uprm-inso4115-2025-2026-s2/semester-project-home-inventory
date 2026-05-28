import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/household_entity.dart';
import '../../domain/entities/household_member_entity.dart';
import '../../domain/usecases/add_household_member.dart';
import '../../domain/usecases/create_household.dart';
import '../../domain/usecases/get_household_by_id.dart';
import '../../domain/usecases/get_household_members.dart';
import '../../domain/usecases/remove_household_member.dart';
import '../../domain/usecases/validate_household_membership.dart';
import 'household_state.dart';

class HouseholdCubit extends Cubit<HouseholdState> {
  final CreateHousehold _createHousehold;
  final GetHouseholdById _getHouseholdById;
  final GetHouseholdMembers _getHouseholdMembers;
  final AddHouseholdMember _addHouseholdMember;
  final RemoveHouseholdMember _removeHouseholdMember;
  final ValidateHouseholdMembership _validateHouseholdMembership;

  int? _currentHouseholdId;

  HouseholdCubit({
    required CreateHousehold createHousehold,
    required GetHouseholdById getHouseholdById,
    required GetHouseholdMembers getHouseholdMembers,
    required AddHouseholdMember addHouseholdMember,
    required RemoveHouseholdMember removeHouseholdMember,
    required ValidateHouseholdMembership validateHouseholdMembership,
  }) : _createHousehold = createHousehold,
       _getHouseholdById = getHouseholdById,
       _getHouseholdMembers = getHouseholdMembers,
       _addHouseholdMember = addHouseholdMember,
       _removeHouseholdMember = removeHouseholdMember,
       _validateHouseholdMembership = validateHouseholdMembership,
       super(const HouseholdInitial());

  Future<void> createHousehold(HouseholdEntity household) async {
    emit(const HouseholdLoading());

    try {
      final createdHousehold = await _createHousehold(household);
      _currentHouseholdId = createdHousehold.id;
      emit(HouseholdLoaded(createdHousehold));
    } catch (error) {
      emit(HouseholdFailure(error.toString()));
    }
  }

  Future<void> loadHousehold(int householdId) async {
    emit(const HouseholdLoading());

    try {
      final household = await _getHouseholdById(householdId);

      if (household == null) {
        emit(const HouseholdEmpty('Household was not found'));
        return;
      }

      _currentHouseholdId = household.id;
      emit(HouseholdLoaded(household));
    } catch (error) {
      emit(HouseholdFailure(error.toString()));
    }
  }

  Future<void> loadMembers(int householdId) async {
    emit(const HouseholdLoading());

    try {
      _currentHouseholdId = householdId;
      final members = await _getHouseholdMembers(householdId);

      if (members.isEmpty) {
        emit(const HouseholdEmpty('No household members found'));
        return;
      }

      emit(HouseholdMembersLoaded(members));
    } catch (error) {
      emit(HouseholdFailure(error.toString()));
    }
  }

  Future<void> addMember(HouseholdMemberEntity member) async {
    emit(const HouseholdLoading());

    try {
      await _addHouseholdMember(member);
      _currentHouseholdId = member.householdId;

      final members = await _getHouseholdMembers(member.householdId);
      emit(HouseholdMembersLoaded(members));
    } catch (error) {
      emit(HouseholdFailure(error.toString()));
    }
  }

  Future<void> removeMember(int memberId) async {
    emit(const HouseholdLoading());

    try {
      await _removeHouseholdMember(memberId);

      if (_currentHouseholdId != null) {
        final members = await _getHouseholdMembers(_currentHouseholdId!);

        if (members.isEmpty) {
          emit(const HouseholdEmpty('No household members found'));
          return;
        }

        emit(HouseholdMembersLoaded(members));
        return;
      }

      emit(const HouseholdActionSuccess('Household member removed'));
    } catch (error) {
      emit(HouseholdFailure(error.toString()));
    }
  }

  Future<void> validateMembership({
    required int householdId,
    required int userId,
    List<MemberRole> allowedRoles = const [],
  }) async {
    emit(const HouseholdLoading());

    try {
      final isValidMember = await _validateHouseholdMembership(
        householdId: householdId,
        userId: userId,
        allowedRoles: allowedRoles,
      );

      emit(HouseholdMembershipValidated(isValidMember));
    } catch (error) {
      emit(HouseholdFailure(error.toString()));
    }
  }

  void reset() {
    _currentHouseholdId = null;
    emit(const HouseholdInitial());
  }
}