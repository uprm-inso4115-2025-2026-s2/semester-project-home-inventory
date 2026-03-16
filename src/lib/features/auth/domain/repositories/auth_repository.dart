// Defines the contract for authentication-related operations,
// such as signing up, signing in, and signing out users. It also
// provides methods to get the current authenticated user and to
// watch for changes in the authentication state.

import '../entities/auth_user.dart';
import '../value_objects/auth_state.dart';

abstract class AuthRepository {
  Future<void> signUp({required String email, required String password});

  Future<void> signIn({required String email, required String password});

  Future<void> signOut();

  AuthUser? getCurrentUser();

  Stream<AuthState> watchAuthState();
}
