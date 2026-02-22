import 'package:dio/dio.dart';

import '../config/app_env.dart';
import '../auth/session_repository.dart';
import '../logging/app_logger.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class DioFactory {
  final AppEnv env;
  final SessionRepository sessionRepository;
  final AppLogger logger;

  /// Any extra interceptors you may want 
  final List<Interceptor> extraInterceptors;

  DioFactory({
    required this.env,
    required this.sessionRepository,
    required this.logger,
    this.extraInterceptors = const [],
  });

  Dio create() {
    final options = BaseOptions(
      baseUrl: env.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      headers: <String, dynamic>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    final dio = Dio(options);

    // Add Auth interceptor (adds Bearer token automatically)
    dio.interceptors.add(AuthInterceptor(sessionRepository));

    // Add any extra interceptors (Inspector / Refresh / custom) or add nw token
    dio.interceptors.addAll(extraInterceptors);

    // Add logging interceptor (only when enabled)
    if (env.enableLogging) {
      dio.interceptors.add(LoggingInterceptor(logger));
    }

    return dio;
  }
}
