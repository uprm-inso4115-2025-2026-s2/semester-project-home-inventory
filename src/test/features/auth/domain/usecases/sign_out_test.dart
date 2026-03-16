import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/auth/domain/usecases/sign_out.dart';
import '../../fakes/fake_auth_repository.dart';

void main() {
  group('SignOut', () {
    // Tests that the use case calls the signOut method on the
    // repository.
    test('calls signOut on repository', () async {
      // Create a fake repository and the use case instance.
      final repository = FakeAuthRepository();
      final useCase = SignOut(repository);

      // Execute the use case.
      await useCase();

      expect(repository.signOutCalled, isTrue);

      await repository.dispose();
    });
  });
}
