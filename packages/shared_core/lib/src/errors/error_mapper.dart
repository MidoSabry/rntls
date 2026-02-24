import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'failure.dart';

class ErrorMapper {
  static Failure toFailure(Object error) {
    if (error is Failure) return error;

    if (error is DioException) {
      final apiEx = _dioToApiException(error);
      return _apiExceptionToFailure(apiEx);
    }

    if (error is ApiException) {
      return _apiExceptionToFailure(error);
    }

    // Any other unexpected error
    return const UnknownFailure('Something went wrong. Please try again.');
  }

  // ---------------------------
  // Dio -> ApiException
  // ---------------------------
  static ApiException _dioToApiException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          type: ApiExceptionType.timeout,
          message: 'Request timed out. Please try again.',
        );

      case DioExceptionType.connectionError:
        return const ApiException(
          type: ApiExceptionType.network,
          message: 'No internet connection. Please check your network.',
        );

      case DioExceptionType.cancel:
        return const ApiException(
          type: ApiExceptionType.unknown,
          message: 'Request cancelled.',
        );

      case DioExceptionType.badResponse:
        return _fromBadResponse(e);

      case DioExceptionType.badCertificate:
        return const ApiException(
          type: ApiExceptionType.unknown,
          message: 'Bad certificate.',
        );

      case DioExceptionType.unknown:
        return ApiException(
          type: ApiExceptionType.unknown,
          message: e.message ?? 'Unexpected error.',
          data: e.error,
        );
    }
  }

  static ApiException _fromBadResponse(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    // 1) لو السيرفر بيرجع envelope: {success,message,error,data}
    if (data is Map) {
      final success = data['success'] == true;
      if (!success) {
        final msg = _extractMessage(data) ?? 'Request failed';

        // validation: 400/422 أو error map
        final err = data['error'];
        if (status == 400 || status == 422 || err is Map) {
          return ApiException(
            type: ApiExceptionType.validation,
            statusCode: status,
            message: msg,
            data: data, // نخزن envelope كله عشان نطلع fields
          );
        }

        // auth/notfound/server...
        if (status == 401) {
          return ApiException(
            type: ApiExceptionType.unauthorized,
            statusCode: status,
            message: msg,
            data: data,
          );
        }
        if (status == 403) {
          return ApiException(
            type: ApiExceptionType.forbidden,
            statusCode: status,
            message: msg,
            data: data,
          );
        }
        if (status == 404) {
          return ApiException(
            type: ApiExceptionType.notFound,
            statusCode: status,
            message: msg,
            data: data,
          );
        }
        if (status != null && status >= 500) {
          return ApiException(
            type: ApiExceptionType.server,
            statusCode: status,
            message: msg,
            data: data,
          );
        }

        return ApiException(
          type: ApiExceptionType.unknown,
          statusCode: status,
          message: msg,
          data: data,
        );
      }
    }

    // 2) fallback لو مش envelope
    final serverMsg = _extractMessage(data) ?? 'Request failed';

    if (status == 401) {
      return ApiException(
        type: ApiExceptionType.unauthorized,
        statusCode: status,
        message: serverMsg,
        data: data,
      );
    }
    if (status == 403) {
      return ApiException(
        type: ApiExceptionType.forbidden,
        statusCode: status,
        message: serverMsg,
        data: data,
      );
    }
    if (status == 404) {
      return ApiException(
        type: ApiExceptionType.notFound,
        statusCode: status,
        message: serverMsg,
        data: data,
      );
    }
    if (status == 422 || status == 400) {
      return ApiException(
        type: ApiExceptionType.validation,
        statusCode: status,
        message: serverMsg,
        data: data,
      );
    }
    if (status != null && status >= 500) {
      return ApiException(
        type: ApiExceptionType.server,
        statusCode: status,
        message: serverMsg,
        data: data,
      );
    }

    return ApiException(
      type: ApiExceptionType.unknown,
      statusCode: status,
      message: serverMsg,
      data: data,
    );
  }

  // ---------------------------
  // ApiException -> Failure
  // ---------------------------
  static Failure _apiExceptionToFailure(ApiException ex) {
    switch (ex.type) {
      case ApiExceptionType.network:
        return NetworkFailure(ex.message);

      case ApiExceptionType.timeout:
        return TimeoutFailure(ex.message);

      case ApiExceptionType.unauthorized:
        return UnauthorizedFailure(ex.message, statusCode: ex.statusCode);

      case ApiExceptionType.forbidden:
        return ForbiddenFailure(ex.message, statusCode: ex.statusCode);

      case ApiExceptionType.notFound:
        return NotFoundFailure(ex.message, statusCode: ex.statusCode);

      case ApiExceptionType.validation:
        final fields = _extractFieldErrors(ex.data);
        return ValidationFailure(
          ex.message,
          statusCode: ex.statusCode,
          fields: fields,
        );

      case ApiExceptionType.server:
        return ServerFailure(ex.message, statusCode: ex.statusCode);

      case ApiExceptionType.unknown:
        return UnknownFailure(ex.message, statusCode: ex.statusCode);
    }
  }

  // ---------------------------
  // helpers
  // ---------------------------

  /// Try common keys in body/envelope
  static String? _extractMessage(dynamic data) {
    if (data is Map) {
      for (final key in ['message', 'error', 'msg', 'detail']) {
        final v = data[key];
        if (v is String && v.trim().isNotEmpty) return v.trim();
      }
      // بعض الـ APIs تحط الرسالة داخل data.message
      final inner = data['data'];
      if (inner is Map) {
        for (final key in ['message', 'error', 'msg', 'detail']) {
          final v = inner[key];
          if (v is String && v.trim().isNotEmpty) return v.trim();
        }
      }
    }
    return null;
  }

  /// For validation, prefer: envelope.error (map) or body.errors
  static Map<String, dynamic>? _extractFieldErrors(dynamic data) {
    if (data is Map) {
      final err = data['error'];
      if (err is Map) return err.cast<String, dynamic>();

      final errors = data['errors'];
      if (errors is Map) return errors.cast<String, dynamic>();

      final inner = data['data'];
      if (inner is Map) {
        final innerErr = inner['error'];
        if (innerErr is Map) return innerErr.cast<String, dynamic>();

        final innerErrors = inner['errors'];
        if (innerErrors is Map) return innerErrors.cast<String, dynamic>();
      }
    }
    return null;
  }
}