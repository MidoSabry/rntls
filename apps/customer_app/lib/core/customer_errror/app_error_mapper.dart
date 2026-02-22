import 'package:shared_core/shared_core.dart';
import 'app_error.dart';

class AppErrorMapper {
  static AppError fromFailure(Failure f) {
    final title = switch (f) {
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

    return AppError(
      title: title,
      message: f.message,
      statusCode: f.statusCode,
    );
  }
}