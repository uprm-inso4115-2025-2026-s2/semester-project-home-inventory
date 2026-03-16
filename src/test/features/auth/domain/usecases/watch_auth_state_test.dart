import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/auth/domain/entities/auth_user.dart';
import 'package:src/features/auth/domain/value_objects/auth_state.dart';
import 'package:src/features/auth/domain/usecases/watch_auth_state.dart';
import '../../fakes/fake_auth_repository.dart';

void main() {
  group('WatchAuthState', () {
    // Tests that an authenticated state sent by the repository
    // is forwarded by the use case.
    test('emits authenticated state from repository stream', () async {
      // Create a fake repository and the use case instance.
      final repository = FakeAuthRepository();
      final useCase = WatchAuthState(repository);

      // Set up an expectation for the use case to emit an
      // authenticated state
      final future = expectLater(
        useCase(),
        emits(
          isA<AuthState>()
              .having((s) => s.status, 'status', AuthStatus.authenticated)
              .having((s) => s.user?.id, 'user id', '123')
              .having((s) => s.user?.email, 'email', 'user@example.com'),
        ),
      );

      // Simulate an authenticated user coming from the repository
      // stream.
      repository.emit(
        const AuthState.authenticated(
          AuthUser(id: '123', email: 'user@example.com'),
        ),
      );

      await future;
      await repository.dispose();
    });

    // Tests that an unauthenticated state sent by the repository
    // is forwarded by the use case.
    test('emits unauthenticated state from repository stream', () async {
      final repository = FakeAuthRepository();
      final useCase = WatchAuthState(repository);

      final future = expectLater(
        useCase(),
        emits(
          isA<AuthState>()
              .having((s) => s.status, 'status', AuthStatus.unauthenticated)
              .having((s) => s.user, 'user', isNull),
        ),
      );

      repository.emit(const AuthState.unauthenticated());

      await future;
      await repository.dispose();
    });

    // Tests that multiple auth state changes sent by the
    // repository are forwarded by the use case in the correct
    // order.
    test('forwards multiple auth state changes in order', () async {
      final repository = FakeAuthRepository();
      final useCase = WatchAuthState(repository);

      final future = expectLater(
        useCase(),
        emitsInOrder([
          isA<AuthState>().having(
            (s) => s.status,
            'status',
            AuthStatus.unauthenticated,
          ),
          isA<AuthState>()
              .having((s) => s.status, 'status', AuthStatus.authenticated)
              .having((s) => s.user?.email, 'email', 'user@example.com'),
        ]),
      );

      repository.emit(const AuthState.unauthenticated());
      repository.emit(
        const AuthState.authenticated(
          AuthUser(id: '456', email: 'user@example.com'),
        ),
      );

      await future;
      await repository.dispose();
    });
  });
}
