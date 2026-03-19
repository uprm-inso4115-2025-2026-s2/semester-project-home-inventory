// Exception class for authentication-related errors in the
// application.

class AppAuthException implements Exception {
  final String message;

  const AppAuthException(this.message);

  @override
  String toString() => message;
}
