import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/auth/domain/entities/auth_user.dart';
import 'package:src/features/auth/domain/usecases/get_current_user.dart';
import '../../fakes/fake_auth_repository.dart';

void main() {
  group('GetCurrentUser', () {
    test('returns current user from repository', () {
      // Prepare a fake repository with a current authenticated user.
      final repository = FakeAuthRepository()
        ..currentUser = const AuthUser(id: '123', email: 'user@example.com');

      final useCase = GetCurrentUser(repository);

      // Execute the use case to get the current user.
      final result = useCase();

      expect(result, isNotNull);
      expect(result!.id, '123');
      expect(result.email, 'user@example.com');
    });
  });
}
