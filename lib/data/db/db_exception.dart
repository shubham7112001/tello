/// Base class for database-related exceptions
abstract class DBException implements Exception {
  final String message;
  const DBException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Database connection issue
class DBConnectionException extends DBException {
  const DBConnectionException([super.message = "Database Connection Error"]);
}

/// Data not found in DB
class DBNotFoundException extends DBException {
  const DBNotFoundException([super.message = "Data Not Found"]);
}

/// Insert/update/delete operation failed
class DBOperationException extends DBException {
  const DBOperationException([super.message = "Database Operation Failed"]);
}
