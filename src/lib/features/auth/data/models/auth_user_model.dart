// Represents an authenticated user in the system.

import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../domain/entities/auth_user.dart';

class AuthUserModel {
  final String id;
  final String? email;

  const AuthUserModel({required this.id, required this.email});

  /// Creates an [AuthUserModel] from a Supabase [sb.User] object.
  factory AuthUserModel.fromSupabaseUser(sb.User user) {
    return AuthUserModel(id: user.id, email: user.email);
  }

  /// Converts this [AuthUserModel] to an [AuthUser] entity.
  AuthUser toEntity() {
    return AuthUser(id: id, email: email);
  }
}
