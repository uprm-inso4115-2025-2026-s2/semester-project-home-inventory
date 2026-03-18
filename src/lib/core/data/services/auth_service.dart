import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'supabase_service.dart';

class AuthServiceUser {
  final String id;
  final String? email;

  const AuthServiceUser({required this.id, required this.email});
}

class AuthService {
  final SupabaseService supabaseService;

  const AuthService(this.supabaseService);

  sb.GoTrueClient get _auth => supabaseService.auth;

  Future<AuthServiceUser?> signUp({
    required String email,
    required String password,
  }) async {
    final response = await _auth.signUp(email: email, password: password);

    final user = response.user;
    if (user == null) return null;

    return AuthServiceUser(id: user.id, email: user.email);
  }

  Future<AuthServiceUser?> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) return null;

    return AuthServiceUser(id: user.id, email: user.email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  AuthServiceUser? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;

    return AuthServiceUser(id: user.id, email: user.email);
  }

  Stream<AuthServiceUser?> watchCurrentUser() {
    return _auth.onAuthStateChange.map((data) {
      final user = data.session?.user ?? _auth.currentUser;

      if (user == null) return null;

      return AuthServiceUser(id: user.id, email: user.email);
    });
  }
}
