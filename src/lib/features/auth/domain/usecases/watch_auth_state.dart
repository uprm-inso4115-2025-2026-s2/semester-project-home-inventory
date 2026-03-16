// Use case for watching the authentication state of the user. It
// interacts with the AuthRepository to get a stream of
// authentication state changes, allowing the application to
// react to sign-in and sign-out events in real-time.

import '../value_objects/auth_state.dart';
import '../repositories/auth_repository.dart';

/// Use case for observing authentication state changes.
///
/// It provides a stream of [AuthState].
class WatchAuthState {
  /// Repository abstraction used by the use case to access
  /// authentication state.
  final AuthRepository repository;

  /// WatchAuthState use case constructor.
  ///
  /// Takes a [AuthRepository] as a parameter to access the stream
  /// of [AuthState] changes.
  const WatchAuthState(this.repository);

  /// Executes the use case to watch authentication state changes.
  ///
  /// Returns a stream of [AuthState].
  Stream<AuthState> call() {
    return repository.watchAuthState();
  }
}
