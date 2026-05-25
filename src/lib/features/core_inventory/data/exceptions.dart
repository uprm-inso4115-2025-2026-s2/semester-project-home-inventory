/// Thrown when a datasource operation fails.
/// Wraps database-specific errors into a generic interface.
/// 
/// These exceptions are thrown by datasources and caught/wrapped by
/// use cases in the domain layer to maintain Clean Architecture separation.
class DataSourceException implements Exception {
  final String message;
  DataSourceException(this.message);

  @override
  String toString() => 'DataSourceException: $message';
}

/// Thrown when a repository operation fails
/// May wrap DataSourceException or business logic violations
class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}
