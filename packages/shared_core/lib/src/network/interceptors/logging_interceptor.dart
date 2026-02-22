import 'package:dio/dio.dart';
import '../../logging/app_logger.dart';

class LoggingInterceptor extends Interceptor {
  final AppLogger logger;

  LoggingInterceptor(this.logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.d('[DIO] --> ${options.method} ${options.uri}');
    logger.d('[DIO] Headers: ${options.headers}');
    logger.d('[DIO] Query: ${options.queryParameters}');
    logger.d('[DIO] Body: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('[DIO] <-- ${response.statusCode} ${response.requestOptions.uri}');
    logger.d('[DIO] Response: ${response.data}');
    handler.next(response);
  }

@override
void onError(DioException err, ErrorInterceptorHandler handler) {
  final status = err.response?.statusCode;

  final isClientError = status != null && status >= 400 && status < 500;
  final isServerError = status != null && status >= 500;

  // network/timeouts/cancel… إلخ
  final isConnectivityOrTimeout =
      err.type == DioExceptionType.connectionError ||
      err.type == DioExceptionType.connectionTimeout ||
      err.type == DioExceptionType.receiveTimeout ||
      err.type == DioExceptionType.sendTimeout;

  if (isClientError) {
    // متوقع غالبًا (غلط بيانات/صلاحيات/validation)
    logger.d('[DIO] <-- $status ${err.requestOptions.method} ${err.requestOptions.uri}');
    logger.d('[DIO] Client error body: ${err.response?.data}');
  } else if (isServerError || isConnectivityOrTimeout) {
    // مهم
    logger.e(
      '[DIO] ERROR $status ${err.requestOptions.method} ${err.requestOptions.uri}',
      error: err,
      stackTrace: err.stackTrace,
    );
  } else {
    // أي حالة غريبة
    logger.e(
      '[DIO] ERROR ${err.requestOptions.method} ${err.requestOptions.uri}',
      error: err,
      stackTrace: err.stackTrace,
    );
  }

  handler.next(err);
}
}
