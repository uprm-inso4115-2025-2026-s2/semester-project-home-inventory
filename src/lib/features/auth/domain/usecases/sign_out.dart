// Use case for signing out the current user. It interacts with
// the AuthRepository to perform the sign-out operation.

import '../repositories/auth_repository.dart';

/// Use case for signing out the current user.
class SignOut {
  /// Repository abstraction used by the use case.
  final AuthRepository repository;

  /// SignOut use case constructor.
  ///
  /// Takes a [AuthRepository] as a parameter to perform the
  /// sign-out operation.
  const SignOut(this.repository);

  /// Executes the sign out operation.
  ///
  /// Delegates the sign-out process to the repository.
  Future<void> call() {
    return repository.signOut();
  }
}
