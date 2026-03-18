// Communicates with AuthService for authentication operations

import '../../../../core/data/services/auth_service.dart';
import '../../domain/exceptions/auth_exception.dart';
import '../models/auth_user_model.dart';
import 'auth_data_sources.dart';

/// Implementation of [AuthDataSource] using [AuthService] for authentication.
class SupabaseAuthDataSource implements AuthDataSource {
  final AuthService authService;

  const SupabaseAuthDataSource(this.authService);

  @override
  Future<AuthUserModel?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authService.signUp(email: email, password: password);

      if (user == null) return null;
      return AuthUserModel(id: user.id, email: user.email ?? "NONE");
    } catch (_) {
      return null;
    }
  }

  @override
  Future<AuthUserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await authService.signIn(email: email, password: password);

      if (user == null) return null;
      return AuthUserModel(id: user.id, email: user.email ?? "NONE");
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await authService.signOut();
    } catch (e) {
      throw AppAuthException('Sign out failed: $e');
    }
  }

  @override
  AuthUserModel? getCurrentUser() {
    final user = authService.getCurrentUser();
    if (user == null) return null;
    return AuthUserModel(id: user.id, email: user.email ?? "NONE");
  }

  @override
  Stream<AuthUserModel?> watchCurrentUser() {
    return authService.watchCurrentUser().map((user) {
      if (user == null) return null;
      return AuthUserModel(id: user.id, email: user.email ?? "NONE");
    });
  }
}
