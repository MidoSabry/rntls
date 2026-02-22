import 'package:shared_core/shared_core.dart';

sealed class AppResponse<T> {
  const AppResponse();
  bool get isSuccess => this is AppSuccess<T>;
  bool get isFailure => this is AppFailure<T>;
}

class AppSuccess<T> extends AppResponse<T> {
  final T data;
  const AppSuccess(this.data);
}

class AppFailure<T> extends AppResponse<T> {
  final Failure failure;
  const AppFailure(this.failure);
}