import 'dart:async';
import 'package:src/features/auth/data/datasources/auth_data_sources.dart';
import 'package:src/features/auth/data/models/auth_user_model.dart';

/// A fake implementation of the AuthDataSource for testing
/// purposes.
class FakeAuthDataSource implements AuthDataSource {
  // The last email and password passed to signIn or signUp.
  String? lastEmail;
  String? lastPassword;

  // Flag to indicate if signOut was called.
  bool signOutCalled = false;

  // The current user model to be returned by getCurrentUser.
  AuthUserModel? currentUser;

  /// Controller uset to simulate auth state changes in tests.
  final _controller = StreamController<AuthUserModel?>.broadcast();

  @override
  Future<AuthUserModel?> signIn({
    required String email,
    required String password,
  }) async {
    lastEmail = email;
    lastPassword = password;
    return currentUser;
  }

  @override
  Future<AuthUserModel?> signUp({
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
  AuthUserModel? getCurrentUser() => currentUser;

  @override
  Stream<AuthUserModel?> watchCurrentUser() => _controller.stream;

  /// Pushes a new auth user model into the stream for testing
  /// purposes.
  void emit(AuthUserModel? model) => _controller.add(model);

  /// Closes the stream controller.
  Future<void> dispose() async {
    await _controller.close();
  }
}
