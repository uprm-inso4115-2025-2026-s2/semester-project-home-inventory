// Implementation of the AuthRepository interface, using the
// AuthDataSource for data operations

import '../../domain/entities/auth_user.dart';
import '../../domain/value_objects/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_sources.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  const AuthRepositoryImpl({required this.dataSource});

  @override
  Future<void> signUp({required String email, required String password}) {
    return dataSource.signUp(email: email, password: password);
  }

  @override
  Future<void> signIn({required String email, required String password}) {
    return dataSource.signIn(email: email, password: password);
  }

  @override
  Future<void> signOut() {
    return dataSource.signOut();
  }

  @override
  AuthUser? getCurrentUser() {
    return dataSource.getCurrentUser()?.toEntity();
  }

  @override
  Stream<AuthState> watchAuthState() {
    return dataSource.watchAuthState().map((userModel) {
      if (userModel == null) {
        return const AuthState.unauthenticated();
      }

      return AuthState.authenticated(userModel.toEntity());
    });
  }
}
