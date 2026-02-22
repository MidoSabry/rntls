// apps/customer_app/lib/features/auth/data/auth_repository_impl.dart

import 'package:customer_app/features/auth/login/data/session_repository_impl.dart';
import 'package:shared_core/shared_core.dart';

import '../domain/auth_repository.dart';
import 'login_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient api;
  final LocalSessionRepository session;

  AuthRepositoryImpl({
    required this.api,
    required this.session,
  });

  @override
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    final req = LoginRequest(email: email, password: password);

    final data = await api.post<LoginDataDto>(
      '/api/login/',
      body: req.toJson(),
      fromJson: (json) => LoginDataDto.fromJson(json as Map<String, dynamic>),
    );

    // Save for AuthInterceptor
    await session.saveTokens(
      accessToken: data.token,
      refreshToken: data.refreshToken,
    );

    return AuthTokens(
      accessToken: data.token,
      refreshToken: data.refreshToken,
    );
  }
}