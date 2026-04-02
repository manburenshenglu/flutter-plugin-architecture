/// @author xiejl
/// @date 2026/4/2 14:30
/// @description  Token 存储抽象，负责读写 access/refresh token。
abstract class TokenStore {
  Future<String?> readAccessToken();

  Future<String?> readRefreshToken();

  Future<void> writeAccessToken(String token);

  Future<void> writeRefreshToken(String token);

  Future<void> clear();
}
