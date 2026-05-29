import 'package:src/features/auth/domain/entities/auth_user.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final AuthUser user;
  const ProfileLoaded(this.user);
}

class ProfileFailure extends ProfileState {
  final String message;
  const ProfileFailure(this.message);
}
