// Responsible for handling authentication-related data operations,
// such as signing up, signing in, signing out, and retrieving the
// current user.

import '../models/auth_user_model.dart';

abstract class AuthDataSource {
  Future<void> signUp({required String email, required String password});

  Future<void> signIn({required String email, required String password});

  Future<void> signOut();

  AuthUserModel? getCurrentUser();

  Stream<AuthUserModel?> watchAuthState();
}
