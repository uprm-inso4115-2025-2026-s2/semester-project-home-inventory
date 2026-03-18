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

  factory AuthUserModel.fromEntity(AuthUser entity) {
    return AuthUserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      profilePictureUrl: entity.profilePictureUrl,
      birthday: entity.birthday,
    );
  }

  AuthUser toEntity() {
    return AuthUser(
      id: id,
      email: email,
      name: name,
      profilePictureUrl: profilePictureUrl,
      birthday: birthday,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profilePictureUrl': profilePictureUrl,
      'birthday': birthday?.toIso8601String(),
    };
  }

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'])
          : null,
    );
  }
}
