abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([String message = 'No internet connection'])
    : super(message, 'NETWORK_ERROR');
}

class ApiException extends AppException {
  final int? statusCode;

  const ApiException(super.message, {this.statusCode});

  factory ApiException.fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return const ApiException('Bad request', statusCode: 400);
      case 401:
        return const ApiException(
          'Unauthorized - Invalid API key',
          statusCode: 401,
        );
      case 404:
        return const ApiException('City not found', statusCode: 404);
      case 429:
        return const ApiException('Too many requests', statusCode: 429);
      case 500:
        return const ApiException('Server error', statusCode: 500);
      default:
        return ApiException(
          'Request failed with status: $statusCode',
          statusCode: statusCode,
        );
    }
  }
}

class CacheException extends AppException {
  const CacheException([String message = 'Cache operation failed'])
    : super(message, 'CACHE_ERROR');
}

class EncryptionException extends AppException {
  const EncryptionException([String message = 'Encryption operation failed'])
    : super(message, 'ENCRYPTION_ERROR');
}

class ParseException extends AppException {
  const ParseException([String message = 'Failed to parse data'])
    : super(message, 'PARSE_ERROR');
}

class ValidationException extends AppException {
  const ValidationException([String message = 'Validation failed'])
    : super(message, 'VALIDATION_ERROR');
}

class ServerException extends AppException {
  final Map<String, dynamic>? errors;

  const ServerException({String? error, this.errors})
    : super(error ?? 'Server error occurred', 'SERVER_ERROR');
}
