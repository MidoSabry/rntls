

import 'package:shared_core/shared_core.dart';

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