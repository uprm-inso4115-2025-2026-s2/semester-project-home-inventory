// Represents the authentication state of the user in the
// application.

import '../entities/auth_user.dart';

/// Enumeration of possible authentication statuses.
enum AuthStatus { unknown, authenticated, unauthenticated }

/// Represents the authentication state of the user.
class AuthState {
  /// The current authentication status of the user.
  final AuthStatus status;

  /// The currently authenticated user or null if no user is
  /// authenticated.
  final AuthUser? user;

  /// Private constructor for AuthState.
  const AuthState._({required this.status, this.user});

  /// Factory constructor for creating an unknown authentication
  /// state.
  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  /// Factory constructor for creating an unauthenticated state.
  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);

  /// Factory constructor for creating an authenticated state with
  /// the given user.
  const AuthState.authenticated(AuthUser user)
    : this._(status: AuthStatus.authenticated, user: user);
}
