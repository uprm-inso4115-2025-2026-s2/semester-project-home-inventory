import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:src/features/auth/presentation/cubit/auth_state.dart';
import 'package:src/features/auth/domain/usecases/get_current_user.dart';
import 'package:src/features/auth/domain/usecases/watch_current_user.dart';
import 'package:src/features/auth/domain/usecases/sign_in.dart';
import 'package:src/features/auth/domain/usecases/sign_out.dart';
import 'package:src/features/auth/domain/usecases/sign_up.dart';
import 'package:src/features/auth/domain/entities/auth_user.dart';
import '../../auth/fakes/fake_auth_repository.dart';

void main() {
  group('Auth Flow Integration Tests', () {
    late FakeAuthRepository fakeAuthRepository;
    late SignIn signInUseCase;
    late SignOut signOutUseCase;
    late SignUp signUpUseCase;
    late GetCurrentUser getCurrentUserUseCase;
    late WatchCurrentUser watchCurrentUserUseCase;
    late AuthCubit authCubit;

    const testUser = AuthUser(
      id: '123',
      email: 'test@example.com',
      name: 'Test User',
    );

    setUp(() {
      fakeAuthRepository = FakeAuthRepository();
      signInUseCase = SignIn(fakeAuthRepository);
      signOutUseCase = SignOut(fakeAuthRepository);
      signUpUseCase = SignUp(fakeAuthRepository);
      getCurrentUserUseCase = GetCurrentUser(fakeAuthRepository);
      watchCurrentUserUseCase = WatchCurrentUser(fakeAuthRepository);

      authCubit = AuthCubit(
        signInUseCase: signInUseCase,
        signOutUseCase: signOutUseCase,
        signUpUseCase: signUpUseCase,
        getCurrentUserUseCase: getCurrentUserUseCase,
        watchCurrentUserUseCase: watchCurrentUserUseCase,
      );
    });

    tearDown(() {
      authCubit.close();
      fakeAuthRepository.dispose();
    });

    blocTest<AuthCubit, AuthState>(
      'initialize sets AuthUnauthenticated when no user',
      build: () => authCubit,
      act: (cubit) => cubit.initialize(),
      expect: () => [isA<AuthUnauthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'initialize sets AuthAuthenticated when user exists',
      build: () {
        fakeAuthRepository.currentUser = testUser;
        return authCubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () => [isA<AuthAuthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'signIn emits AuthAuthenticated with user',
      build: () {
        fakeAuthRepository.currentUser = testUser;
        return authCubit;
      },
      act: (cubit) =>
          cubit.signIn(email: 'test@example.com', password: 'password'),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'signOut emits AuthUnauthenticated',
      build: () {
        fakeAuthRepository.currentUser = testUser;
        authCubit.initialize(); // Set authenticated state
        return authCubit;
      },
      act: (cubit) => cubit.signOut(),
      expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
    );

    test('auth user ID is accessible for inventory loading', () {
      // This tests that AuthUser.id can be used to load inventory
      // AuthUser.id is a String (UUID from Supabase)

      const authUserId = '550e8400-e29b-41d4-a716-446655440000'; // Example UUID
      const authUser = AuthUser(id: authUserId, email: 'test@example.com');

      // Verify we can extract the ID
      expect(authUser.id, isA<String>());
      expect(authUser.id.length, greaterThan(0));

      // Verify numeric parsing would fail (as expected for UUID)
      final numericId = int.tryParse(authUser.id);
      expect(numericId, isNull);
    });

    blocTest<AuthCubit, AuthState>(
      'watch current user stream updates state on auth changes',
      build: () {
        fakeAuthRepository.currentUser = testUser;
        return authCubit;
      },
      act: (cubit) async {
        cubit.initialize();
        await Future.delayed(Duration(milliseconds: 100));
        // Simulate auth state change
        fakeAuthRepository.emit(null);
        await Future.delayed(Duration(milliseconds: 100));
      },
      expect: () => [isA<AuthAuthenticated>(), isA<AuthUnauthenticated>()],
    );
  });
}
