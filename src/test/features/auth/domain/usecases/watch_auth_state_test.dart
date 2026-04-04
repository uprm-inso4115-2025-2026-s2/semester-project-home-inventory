import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/auth/domain/entities/auth_user.dart';
import 'package:src/features/auth/domain/usecases/watch_current_user.dart';
import '../../fakes/fake_auth_repository.dart';

void main() {
  group('WatchAuthState', () {
    // Tests that an authenticated state sent by the repository
    // is forwarded by the use case.
    test('emits authenticated user from repository stream', () async {
      // Create a fake repository and the use case instance.
      final repository = FakeAuthRepository();
      final useCase = WatchCurrentUser(repository);

      // Set up an expectation for the use case to emit an
      // authenticated user.
      final future = expectLater(
        useCase(),
        emits(
          isA<AuthUser>()
              .having((u) => u.id, 'user_id', '123')
              .having((u) => u.email, 'email', 'user@example.com'),
        ),
      );

      // Simulate an authenticated user coming from the repository
      // stream.
      repository.emit(const AuthUser(id: '123', email: 'user@example.com'));

      await future;
      await repository.dispose();
    });

    // Tests that a null user sent by the repository
    // is forwarded by the use case.
    test('emits null when repository stream emits no user', () async {
      final repository = FakeAuthRepository();
      final useCase = WatchCurrentUser(repository);

      final future = expectLater(useCase(), emits(isNull));

      repository.emit(null);

      await future;
      await repository.dispose();
    });

    // Tests that multiple current-user changes sent by the
    // repository are forwarded by the use case in the correct
    // order.
    test('forwards multiple auth state changes in order', () async {
      final repository = FakeAuthRepository();
      final useCase = WatchCurrentUser(repository);

      final future = expectLater(
        useCase(),
        emitsInOrder([
          isNull,
          isA<AuthUser>()
              .having((u) => u.id, 'user id', '456')
              .having((u) => u.email, 'email', 'user@example.com'),
        ]),
      );

      repository.emit(null);
      repository.emit(const AuthUser(id: '456', email: 'user@example.com'));

      await future;
      await repository.dispose();
    });
  });
}
