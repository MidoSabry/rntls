class InspectorModel {
  String id;
  int? statusCode;
  String? startTime;
  String? endTime;
  String? contentType;
  String? authorization;
  String? error;
  String? method;
  DateTime? startTimeDate;
  String? callingTime;
  Uri? uri;
  String? path;
  String? baseUrl;
  dynamic data; // request body
  dynamic responseBody;
  Map<String, dynamic>? queryParameters;
  Map<String, dynamic>? extra;
  dynamic responseHeaders;
  dynamic requestHeaders;

  InspectorModel({
    required this.id,
    this.uri,
    this.path,
    this.callingTime,
    this.baseUrl,
    this.data,
    this.queryParameters,
    this.extra,
    this.statusCode,
    this.method,
    this.endTime,
    this.error,
    this.responseBody,
    this.authorization,
    this.contentType,
    this.startTimeDate,
    this.startTime,
    this.responseHeaders,
    this.requestHeaders,
  });
}
