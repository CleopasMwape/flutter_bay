abstract class AppException implements Exception {
  AppException(this.message, {this.code});
  final String message;
  final String? code;

  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException(super.message, {super.code});
}

class NetworkException extends AppException {
  NetworkException(super.message, {super.code});
}

class CacheException extends AppException {
  CacheException(super.message, {super.code});
}

class ParseException extends AppException {
  ParseException(super.message, {super.code});
}

class TimeoutException extends AppException {
  TimeoutException(super.message, {super.code});
}
