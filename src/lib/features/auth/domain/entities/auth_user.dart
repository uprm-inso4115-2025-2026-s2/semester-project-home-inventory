/// Represents an authenticated user in the system.
class AuthUser {
  /// Unique identifier for the user.
  final String id;

  /// Email address of the user. May be null to match the return
  /// type of the data source, but should be non-null for
  /// authenticated users.
  final String? email;

  /// User display name.
  final String? name;

  /// URL to the user's profile picture.
  final String? profilePictureUrl;

  /// User's birthdate.
  final DateTime? birthday;

  /// AuthUser entity constructor with required id and email.
  const AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.profilePictureUrl,
    this.birthday,
  });
}
