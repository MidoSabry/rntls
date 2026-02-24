sealed class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, {super.statusCode});
}

final class ForbiddenFailure extends Failure {
  const ForbiddenFailure(super.message, {super.statusCode});
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.statusCode});
}

final class ValidationFailure extends Failure {
  final Map<String, dynamic>? fields;
  const ValidationFailure(
    super.message, {
    super.statusCode,
    this.fields,
  });
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.statusCode});
}