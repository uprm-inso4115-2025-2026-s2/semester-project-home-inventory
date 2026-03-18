// Represents an authenticated user in the system.

import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    super.name,
    super.profilePictureUrl,
    super.birthday,
  });
}
