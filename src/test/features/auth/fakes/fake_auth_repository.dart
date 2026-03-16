import 'dart:async';
import 'package:src/features/auth/domain/entities/auth_user.dart';
import 'package:src/features/auth/domain/value_objects/auth_state.dart';
import 'package:src/features/auth/domain/repositories/auth_repository.dart';

/// A fake implementation of AuthRepository for testing purposes.
///
/// To simulate authentication operations without a real backend
/// set up.
class FakeAuthRepository implements AuthRepository {
  // The last email and password passed to signIn or signUp.
  String? lastEmail;
  String? lastPassword;
  bool signOutCalled = false;
  AuthUser? currentUser;

  // A controller to emit AuthState changes.
  final _controller = StreamController<AuthState>.broadcast();

  @override
  Future<void> signIn({required String email, required String password}) async {
    lastEmail = email;
    lastPassword = password;
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    lastEmail = email;
    lastPassword = password;
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }

  @override
  AuthUser? getCurrentUser() => currentUser;

  @override
  Stream<AuthState> watchAuthState() => _controller.stream;

  // Pushes a new auth state into the stream for testing purposes.
  void emit(AuthState state) => _controller.add(state);

  // Closes the stream controller.
  Future<void> dispose() async {
    await _controller.close();
  }
}
