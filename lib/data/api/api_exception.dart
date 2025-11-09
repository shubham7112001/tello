/// Base class for all API-related exceptions
abstract class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when there is no internet or timeout
class NetworkException extends ApiException {
  const NetworkException([super.message = "No Internet Connection"]);
}

/// Thrown when server sends 5xx or unexpected response
class ServerException extends ApiException {
  const ServerException([super.message = "Server Error"]);
}

/// Thrown when authentication fails (401, 403)
class AuthException extends ApiException {
  const AuthException([super.message = "Authentication Failed"]);
}

/// Thrown when API returns something invalid (parsing, 422 etc.)
class BadRequestException extends ApiException {
  const BadRequestException([super.message = "Invalid Request"]);
}

class UserNotFoundException extends ApiException {
  const UserNotFoundException([super.message = "User not found"]);
}
