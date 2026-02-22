import 'package:dio/dio.dart';
import '../errors/error_mapper.dart';
import '../errors/failure.dart';
import 'api_envelope.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final res = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return _parseEnvelope(res.data, fromJson);
    } catch (e) {
      throw ErrorMapper.toFailure(e);
    }
  }

  Future<T> post<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final res = await _dio.post(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return _parseEnvelope(res.data, fromJson);
    } catch (e) {
      throw ErrorMapper.toFailure(e);
    }
  }

  Future<T> put<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final res = await _dio.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return _parseEnvelope(res.data, fromJson);
    } catch (e) {
      throw ErrorMapper.toFailure(e);
    }
  }

  Future<T> delete<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final res = await _dio.delete(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return _parseEnvelope(res.data, fromJson);
    } catch (e) {
      throw ErrorMapper.toFailure(e);
    }
  }

  T _parseEnvelope<T>(dynamic raw, T Function(dynamic json) fromJson) {
    if (raw is! Map<String, dynamic>) {
      return fromJson(raw);
    }

    final envelope = ApiEnvelope<T>.fromJson(raw, fromJson);

  
    if (!envelope.success) {
      final msg = envelope.message?.trim().isNotEmpty == true
          ? envelope.message!.trim()
          : 'Request failed';

      if (envelope.error is Map) {
        throw ValidationFailure(
          msg,
          statusCode: null,
          fields: (envelope.error as Map).cast<String, dynamic>(),
        );
      }
      throw ServerFailure(msg);
    }

    //success=true لكن data=null
    if (envelope.data == null) {
      throw const UnknownFailure('Empty response data.');
    }

    return envelope.data as T;
  }
}
