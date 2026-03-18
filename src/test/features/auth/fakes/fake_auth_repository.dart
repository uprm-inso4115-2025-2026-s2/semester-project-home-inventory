import 'dart:async';
import 'package:src/features/auth/domain/entities/auth_user.dart';
import 'package:src/features/auth/domain/repositories/auth_repository.dart';

/// A fake implementation of AuthRepository for testing purposes.
///
/// To simulate authentication operations without a real backend
/// set up.
class FakeAuthRepository implements AuthRepository {
  // The last email and password passed to signIn or signUp.
  String? lastEmail;
  String? lastPassword;

  // Flag to indicate if signOut was called.
  bool signOutCalled = false;

  // The current authenticated user, if any.
  AuthUser? currentUser;

  // A controller to emit AuthState changes.
  final _controller = StreamController<AuthUser?>.broadcast();

  @override
  Future<AuthUser?> signIn({
    required String email,
    required String password,
  }) async {
    lastEmail = email;
    lastPassword = password;
    return currentUser;
  }

  @override
  Future<AuthUser?> signUp({
    required String email,
    required String password,
  }) async {
    lastEmail = email;
    lastPassword = password;
    return currentUser;
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }

  @override
  AuthUser? getCurrentUser() => currentUser;

  @override
  Stream<AuthUser?> watchCurrentUser() => _controller.stream;

  // Pushes a new auth state into the stream for testing purposes.
  void emit(AuthUser? state) => _controller.add(state);

  // Closes the stream controller.
  Future<void> dispose() async {
    await _controller.close();
  }
}
