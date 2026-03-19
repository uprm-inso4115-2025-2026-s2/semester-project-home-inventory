import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/auth/domain/usecases/sign_up.dart';
import '../../fakes/fake_auth_repository.dart';

void main() {
  group('SignUp', () {
    // Tests that the use case passes the provided email and
    // password to the repository.
    test('passes email and password to repository', () async {
      // Create a fake repository and the use case instance.
      final repository = FakeAuthRepository();
      final useCase = SignUp(repository);

      // Execute the use case with test email and password.
      await useCase(email: 'newuser@example.com', password: 'secret123');

      expect(repository.lastEmail, 'newuser@example.com');
      expect(repository.lastPassword, 'secret123');

      await repository.dispose();
    });
  });
}
