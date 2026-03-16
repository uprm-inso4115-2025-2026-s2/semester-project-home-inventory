/// Represents an authenticated user in the system.
class AuthUser {
  /// Unique identifier for the user.
  final String id;

  /// Email address of the user. May be null to match the return
  /// type of the data source, but should be non-null for
  /// authenticated users.
  final String? email;

  /// AuthUser constructor with required id and email.
  const AuthUser({required this.id, required this.email});
}
