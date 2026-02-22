import 'package:dio/dio.dart';
import '../../auth/session_repository.dart';

class AuthInterceptor extends Interceptor {
  final SessionRepository sessionRepository;

  AuthInterceptor(this.sessionRepository);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await sessionRepository.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
