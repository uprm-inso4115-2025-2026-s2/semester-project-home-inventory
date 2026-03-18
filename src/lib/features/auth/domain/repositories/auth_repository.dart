// Defines the contract for authentication-related operations,
// such as signing up, signing in, and signing out users. It also
// provides methods to get the current authenticated user and to
// watch for changes to the current user.

import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser?> signUp({required String email, required String password});

  Future<AuthUser?> signIn({required String email, required String password});

  Future<void> signOut();

  AuthUser? getCurrentUser();

  Stream<AuthUser?> watchCurrentUser();
}
