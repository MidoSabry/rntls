// apps/customer_app/lib/core/auth/local_session_repository.dart

import 'package:shared_core/shared_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSessionRepository implements SessionRepository {
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';

  final SharedPreferences prefs;
  LocalSessionRepository(this.prefs);

  @override
  Future<String?> getAccessToken() async => prefs.getString(_kAccess);

  @override
  Future<String?> getRefreshToken() async => prefs.getString(_kRefresh);

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await prefs.setString(_kAccess, accessToken);
    if (refreshToken != null) {
      await prefs.setString(_kRefresh, refreshToken);
    }
  }

  Future<void> clear() async {
    await prefs.remove(_kAccess);
    await prefs.remove(_kRefresh);
  }
}