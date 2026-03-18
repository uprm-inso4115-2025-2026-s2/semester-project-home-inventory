import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/auth/domain/entities/auth_user.dart';
import 'package:src/features/auth/data/models/auth_user_model.dart';
import 'package:src/features/auth/data/repositories/auth_repository_impl.dart';
import '../../fakes/fake_auth_data_source.dart';

void main() {
  group('AuthRepositoryImpl', () {
    test('getCurrentUser returns current user from datasource', () {
      // Prepare a fake data source with the current user model.
      final dataSource = FakeAuthDataSource()
        ..currentUser = const AuthUserModel(
          id: 'abc',
          email: 'abc@example.com',
        );

      final repository = AuthRepositoryImpl(dataSource: dataSource);

      // Request the current user from the repository.
      final result = repository.getCurrentUser();

      expect(result, isNotNull);
      expect(result!.id, 'abc');
      expect(result.email, 'abc@example.com');
    });

    test(
      'watchCurrentUser emits authenticated user when datasource emits user',
      () async {
        // Create a fake data source and repository.
        final dataSource = FakeAuthDataSource();
        final repository = AuthRepositoryImpl(dataSource: dataSource);

        final future = expectLater(
          repository.watchCurrentUser(),
          emits(
            isA<AuthUser>()
                .having((u) => u.id, 'user id', '1')
                .having((u) => u.email, 'email', 'user@test.com'),
          ),
        );

        // Emit an authenticated user from the data source.
        dataSource.emit(const AuthUserModel(id: '1', email: 'user@test.com'));

        await future;
        await dataSource.dispose();
      },
    );

    test('watchCurrentUser emits null when datasource emits null', () async {
      final dataSource = FakeAuthDataSource();
      final repository = AuthRepositoryImpl(dataSource: dataSource);

      // Expect the stream to emit null when no authenticated
      // user is available.
      final future = expectLater(repository.watchCurrentUser(), emits(isNull));

      // Emit null from the data source to simulate the absence
      // of an authenticated user.
      dataSource.emit(null);

      await future;
      await dataSource.dispose();
    });

    test('signIn delegates to datasource', () async {
      final dataSource = FakeAuthDataSource();
      final repository = AuthRepositoryImpl(dataSource: dataSource);

      await repository.signIn(email: 'repo@test.com', password: 'pass123');

      expect(dataSource.lastEmail, 'repo@test.com');
      expect(dataSource.lastPassword, 'pass123');

      await dataSource.dispose();
    });
  });
}
