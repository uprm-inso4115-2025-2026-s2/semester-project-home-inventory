// Use case for retrieving the currently authenticated user. It
// interacts with the AuthRepository to get the current user's
// information.

import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Use case for retrieving the currently authenticated user.
class GetCurrentUser {
  /// Repository abstraction used by the use case to access the
  /// current user information.
  final AuthRepository repository;

  /// GetCurrentUser use case constructor.
  ///
  /// Takes a [AuthRepository] as a parameter to access the current
  /// user information.
  const GetCurrentUser(this.repository);

  /// Executes the use case to retrieve the currently
  /// authenticated user.
  ///
  /// Returns an [AuthUser] if a user is currently authenticated, or
  /// null if no user is authenticated.
  AuthUser? call() {
    return repository.getCurrentUser();
  }
}
