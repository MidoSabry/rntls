import 'package:dio/dio.dart';
import 'package:shared_core/src/inspector/inspector_model.dart';
import 'package:shared_core/src/inspector/inspector_store.dart';

class InspectorInterceptor extends Interceptor {
  final InspectorStore store;

  InspectorInterceptor(this.store);

  static const _key = '__inspector_id__';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final now = DateTime.now();
    final id = '${now.microsecondsSinceEpoch}';

    // save id in request extras so we can update same entry later
    options.extra[_key] = id;

    final model = InspectorModel(
      id: id,
      method: options.method,
      uri: options.uri,
      path: options.path,
      baseUrl: options.baseUrl,
      startTimeDate: now,
      startTime: _fmtTime(now),
      requestHeaders: Map<String, dynamic>.from(options.headers),
      queryParameters: Map<String, dynamic>.from(options.queryParameters),
      data: options.data,
      extra: Map<String, dynamic>.from(options.extra),
      authorization: options.headers['Authorization']?.toString(),
      contentType: options.headers['Content-Type']?.toString(),
    );

    store.add(model);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final id = response.requestOptions.extra[_key]?.toString();
    if (id != null) {
      final now = DateTime.now();

      final updated = _copyAndUpdate(
        store,
        id,
        (old) => InspectorModel(
          id: old.id,
          method: old.method,
          uri: old.uri,
          path: old.path,
          baseUrl: old.baseUrl,
          startTimeDate: old.startTimeDate,
          startTime: old.startTime,
          callingTime: _durationMs(old.startTimeDate, now),
          endTime: _fmtTime(now),
          statusCode: response.statusCode,
          data: old.data,
          queryParameters: old.queryParameters,
          extra: old.extra,
          requestHeaders: old.requestHeaders,
          responseHeaders: response.headers.map,
          responseBody: response.data,
          authorization: old.authorization,
          contentType: old.contentType,
          error: null,
        ),
      );

      if (updated != null) store.update(id, updated);
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final id = err.requestOptions.extra[_key]?.toString();
    if (id != null) {
      final now = DateTime.now();

      final updated = _copyAndUpdate(
        store,
        id,
        (old) => InspectorModel(
          id: old.id,
          method: old.method,
          uri: old.uri,
          path: old.path,
          baseUrl: old.baseUrl,
          startTimeDate: old.startTimeDate,
          startTime: old.startTime,
          callingTime: _durationMs(old.startTimeDate, now),
          endTime: _fmtTime(now),
          statusCode: err.response?.statusCode,
          data: old.data,
          queryParameters: old.queryParameters,
          extra: old.extra,
          requestHeaders: old.requestHeaders,
          responseHeaders: err.response?.headers.map,
          responseBody: err.response?.data,
          authorization: old.authorization,
          contentType: old.contentType,
          error: err.message,
        ),
      );

      if (updated != null) store.update(id, updated);
    }

    handler.next(err);
  }

  InspectorModel? _copyAndUpdate(
    InspectorStore store,
    String id,
    InspectorModel Function(InspectorModel old) builder,
  ) {
    final old = store.items.cast<InspectorModel?>().firstWhere(
          (e) => e?.id == id,
          orElse: () => null,
        );
    if (old == null) return null;
    return builder(old);
  }

  static String _fmtTime(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }

  static String? _durationMs(DateTime? start, DateTime end) {
    if (start == null) return null;
    final ms = end.difference(start).inMilliseconds;
    return '${ms}ms';
  }
}
