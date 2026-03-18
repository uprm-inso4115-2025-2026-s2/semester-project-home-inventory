// Use case for watching the authentication state of the user. It
// interacts with the AuthRepository to get a stream of
// the current user, allowing the presentation layer to
// react to sign-in and sign-out events.

import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Use case for observing authentication state changes.
///
/// It provides a stream of [AuthUser].
class WatchCurrentUser {
  /// Repository abstraction used by the use case to access
  /// authentication state.
  final AuthRepository repository;

  /// WatchAuthState use case constructor.
  ///
  /// Takes a [AuthRepository] as a parameter to access the stream
  /// of [AuthUser] changes.
  const WatchCurrentUser(this.repository);

  /// Executes the use case to watch authentication state changes.
  ///
  /// Returns a stream of [AuthUser].
  Stream<AuthUser?> call() {
    return repository.watchCurrentUser();
  }
}
