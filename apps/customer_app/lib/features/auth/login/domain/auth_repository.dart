// apps/customer_app/lib/features/auth/domain/auth_repository.dart

class AuthTokens {
  final String accessToken;
  final String? refreshToken;

  const AuthTokens({
    required this.accessToken,
    this.refreshToken,
  });
}

abstract class AuthRepository {
  Future<AuthTokens> login({
    required String email,
    required String password,
  });
}