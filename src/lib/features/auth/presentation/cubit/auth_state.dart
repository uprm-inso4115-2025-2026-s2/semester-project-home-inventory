import '../../domain/entities/auth_user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

class AuthState {
  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;

  const AuthState({required this.status, this.user, this.errorMessage});

  const AuthState.initial()
    : status = AuthStatus.initial,
      user = null,
      errorMessage = null;

  const AuthState.loading()
    : status = AuthStatus.loading,
      user = null,
      errorMessage = null;

  const AuthState.authenticated(AuthUser this.user)
    : status = AuthStatus.authenticated,
      errorMessage = null;

  const AuthState.unauthenticated()
    : status = AuthStatus.unauthenticated,
      user = null,
      errorMessage = null;

  const AuthState.failure(String this.errorMessage)
    : status = AuthStatus.failure,
      user = null;
}
