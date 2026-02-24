import 'package:shared_core/shared_core.dart';

Future<AppResponse<T>> responseHelper<T>(Future<T> Function() action) async {
  try {
    final data = await action();
    return AppSuccess(data);
  } catch (e) {
    final failure = e is Failure ? e : ErrorMapper.toFailure(e);
    return AppFailure(failure);
  }
}