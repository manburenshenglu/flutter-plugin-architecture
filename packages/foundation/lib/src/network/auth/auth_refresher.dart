/// @author xiejl
/// @date 2026/4/2 14:30
/// @description  Token 刷新抽象，负责在 access token 失效时换取新 token。
abstract class AuthRefresher {
  Future<RefreshedToken?> refreshToken({String? refreshToken});
}

class RefreshedToken {
  const RefreshedToken({required this.accessToken, this.refreshToken});

  final String accessToken;
  final String? refreshToken;
}
