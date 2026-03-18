import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/auth/domain/usecases/sign_in.dart';
import '../../fakes/fake_auth_repository.dart';

void main() {
  group('SignIn', () {
    test('passes email and password to repository', () async {
      // Create a fake repository and the use case
      final repository = FakeAuthRepository();
      final useCase = SignIn(repository);

      // Call the use case with test email and password
      await useCase(email: 'user@test.com', password: 'password123');

      expect(repository.lastEmail, 'user@test.com');
      expect(repository.lastPassword, 'password123');
    });
  });
}
