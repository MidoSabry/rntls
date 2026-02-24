import 'package:shared_core/shared_core.dart';
import 'app_error.dart';

class AppErrorMapper {
  static AppError fromFailure(
    Failure f, {
    String? messageOverride,
    String? titleOverride,
    String? codeOverride,
  }) {
    final title = titleOverride ?? switch (f) {
      NetworkFailure() => 'No Internet',
      TimeoutFailure() => 'Timeout',
      UnauthorizedFailure() => 'Unauthorized',
      ForbiddenFailure() => 'Forbidden',
      NotFoundFailure() => 'Not Found',
      ValidationFailure() => 'Validation Error',
      ServerFailure() => 'Server Error',
      UnknownFailure() => 'Error',
      // ignore: unreachable_switch_case
      (_) => 'Error',
    };

    final msg = (messageOverride != null && messageOverride.trim().isNotEmpty)
        ? messageOverride.trim()
        : f.message;

    return AppError(
      title: title,
      message: msg,
      statusCode: f.statusCode,
      code: codeOverride,
    );
  }
}