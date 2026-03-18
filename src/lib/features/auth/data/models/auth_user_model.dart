// Represents an authenticated user in the system.

import '../../domain/entities/auth_user.dart';

class AuthUserModel {
  final String id;
  final String? email;
  final String? name;
  final String? profilePictureUrl;
  final DateTime? birthday;

  const AuthUserModel({
    required this.id,
    required this.email,
    this.name,
    this.profilePictureUrl,
    this.birthday,
  });

  /// Converts this [AuthUserModel] to an [AuthUser] entity.
  AuthUser toEntity() {
    return AuthUser(
      id: id,
      email: email,
      name: name,
      profilePictureUrl: profilePictureUrl,
      birthday: birthday,
    );
  }
}
