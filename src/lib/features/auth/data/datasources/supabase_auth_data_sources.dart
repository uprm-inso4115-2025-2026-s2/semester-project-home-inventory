// Communicates with Supabase for authentication operations

import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../domain/exceptions/auth_exception.dart';
import '../models/auth_user_model.dart';
import 'auth_data_sources.dart';

/// Implementation of AuthDataSource using Supabase for authentication.
class SupabaseAuthDataSource implements AuthDataSource {
  final sb.SupabaseClient client;

  SupabaseAuthDataSource(this.client);

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      await client.auth.signUp(email: email, password: password);
    } on sb.AuthException catch (e) {
      throw AppAuthException(e.message);
    } catch (e) {
      throw AppAuthException('Sign up failed: $e');
    }
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await client.auth.signInWithPassword(email: email, password: password);
    } on sb.AuthException catch (e) {
      throw AppAuthException(e.message);
    } catch (e) {
      throw AppAuthException('Sign in failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } on sb.AuthException catch (e) {
      throw AppAuthException(e.message);
    } catch (e) {
      throw AppAuthException('Sign out failed: $e');
    }
  }

  @override
  AuthUserModel? getCurrentUser() {
    final user = client.auth.currentUser;
    if (user == null) return null;
    return AuthUserModel.fromSupabaseUser(user);
  }

  @override
  Stream<AuthUserModel?> watchAuthState() {
    return client.auth.onAuthStateChange.map((data) {
      final session = data.session;
      final user = session?.user ?? client.auth.currentUser;

      if (user == null) return null;
      return AuthUserModel.fromSupabaseUser(user);
    });
  }
}
