// apps/customer_app/lib/features/auth/domain/auth_repository.dart

import '../../../../core/customer_network/app_response.dart';

class AuthTokens {
  final String accessToken;
  final String? refreshToken;

  const AuthTokens({
    required this.accessToken,
    this.refreshToken,
  });
}

abstract class AuthRepository {
  Future<AppResponse<AuthTokens>> login({
    required String email,
    required String password,
  });
}