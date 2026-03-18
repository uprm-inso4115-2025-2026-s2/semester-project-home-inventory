// Represents an authenticated user in the system.

import '../../domain/entities/auth_user.dart';

class AuthUserModel {
  final String id;
  final String? email;

  const AuthUserModel({required this.id, required this.email});

  /// Converts this [AuthUserModel] to an [AuthUser] entity.
  AuthUser toEntity() {
    return AuthUser(id: id, email: email);
  }
}
