class ApiEnvelope<T> {
  final bool success;
  final String? message;
  final T? data;

  /// Can be String (e.g. "Unauthorized") OR Map (field errors)
  final dynamic error;

  ApiEnvelope({
    required this.success,
    required this.message,
    required this.data,
    required this.error,
  });

  factory ApiEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) dataParser,
  ) {
    return ApiEnvelope<T>(
      success: json['success'] == true,
      message: json['message']?.toString(),
      data: json['data'] == null ? null : dataParser(json['data']),
      error: json['error'],
    );
  }
}
