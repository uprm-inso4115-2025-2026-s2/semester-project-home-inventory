// Use case for signing in a user with email and password. It
// interacts with the AuthRepository to perform the sign-in
// operation.

import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing in a user with email and password.
class SignIn {
  /// Repository abstraction used by the use case.
  final AuthRepository repository;

  /// SignIn use case constructor.
  ///
  /// Takes a [AuthRepository] as a parameter to perform the
  /// sign-in operation.
  const SignIn(this.repository);

  /// Executes the sign-in operation with the provided email and
  /// password.
  ///
  /// Delegates the sign-in process to the repository, passing the
  /// email and password.
  Future<AuthUser?> call({required String email, required String password}) {
    return repository.signIn(email: email, password: password);
  }
}
