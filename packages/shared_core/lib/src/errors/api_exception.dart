enum ApiExceptionType {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  validation,
  server,
  unknown,
}

class ApiException implements Exception {
  final ApiExceptionType type;
  final String message;
  final int? statusCode;

  final dynamic data;

  const ApiException({
    required this.type,
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() =>
      'ApiException(type: $type, statusCode: $statusCode, message: $message)';
}