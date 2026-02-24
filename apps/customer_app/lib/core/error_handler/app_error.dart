class AppError {
  final String title;
  final String message;
  final int? statusCode;
  final String? code;

  const AppError({
    required this.title,
    required this.message,
    this.statusCode,
    this.code,
  });

  bool get isUnauthorized => statusCode == 401;
}
