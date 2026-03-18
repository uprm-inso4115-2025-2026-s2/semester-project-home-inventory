// Use case for signing up a new user with email and password. It
//  interacts with the AuthRepository to perform the sign-up
// operation.

import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing up a new user with email and password.
class SignUp {
  /// Repository abstraction used by the use case.
  final AuthRepository repository;

  /// SignUp use case constructor.
  ///
  /// Takes a [AuthRepository] as a parameter to perform the
  /// sign-up operation.
  const SignUp(this.repository);

  /// Executes the sign up operation.
  ///
  /// Passes the provided [email] and [password] to the repository.
  Future<AuthUser?> call({required String email, required String password}) {
    return repository.signUp(email: email, password: password);
  }
}
