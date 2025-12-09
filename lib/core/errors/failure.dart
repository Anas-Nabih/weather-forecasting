import 'package:equatable/equatable.dart';

import 'app_exception.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  List<Object?> get props => [message, code];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);

  factory NetworkFailure.fromException(NetworkException exception) {
    return NetworkFailure(exception.message);
  }
}

class ApiFailure extends Failure {
  final int? statusCode;

  const ApiFailure(super.message, [this.statusCode, super.code]);

  factory ApiFailure.fromException(ApiException exception) {
    return ApiFailure(exception.message, exception.statusCode, exception.code);
  }
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to load cached data']);

  factory CacheFailure.fromException(CacheException exception) {
    return CacheFailure(exception.message);
  }
}

class EncryptionFailure extends Failure {
  const EncryptionFailure([super.message = 'Failed to encrypt/decrypt data']);

  factory EncryptionFailure.fromException(EncryptionException exception) {
    return EncryptionFailure(exception.message);
  }
}

class ParseFailure extends Failure {
  const ParseFailure([super.message = 'Failed to parse data']);

  factory ParseFailure.fromException(ParseException exception) {
    return ParseFailure(exception.message);
  }
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred']);
}
