// Implementation of the AuthRepository interface, using the
// AuthDataSource for data operations

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_sources.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  const AuthRepositoryImpl({required this.dataSource});

  @override
  Future<AuthUser?> signUp({
    required String email,
    required String password,
  }) async {
    final userModel = await dataSource.signUp(email: email, password: password);
    return userModel?.toEntity();
  }

  @override
  Future<AuthUser?> signIn({
    required String email,
    required String password,
  }) async {
    final userModel = await dataSource.signIn(email: email, password: password);
    return userModel?.toEntity();
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
  Stream<AuthUser?> watchCurrentUser() {
    return dataSource.watchCurrentUser().map((userModel) {
      return userModel?.toEntity();
    });
  }
}
