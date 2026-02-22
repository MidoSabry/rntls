abstract class SessionRepository {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
}
