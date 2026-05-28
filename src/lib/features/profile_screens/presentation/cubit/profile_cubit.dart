import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/features/auth/domain/usecases/get_current_user.dart';
import 'package:src/features/auth/domain/usecases/sign_out.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetCurrentUser getCurrentUserUseCase;
  final SignOut signOutUseCase;

  ProfileCubit({
    required this.getCurrentUserUseCase,
    required this.signOutUseCase,
  }) : super(const ProfileInitial());

  void loadProfile() {
    final user = getCurrentUserUseCase();
    if (user != null) {
      emit(ProfileLoaded(user));
    } else {
      emit(const ProfileFailure('No user signed in'));
    }
  }

  Future<void> signOut() async {
    emit(const ProfileLoading());
    try {
      await signOutUseCase();
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}
