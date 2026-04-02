import 'auth_refresher.dart';

/// @author xiejl
/// @date 2026/4/2 14:30
/// @description  默认 token 刷新器，占位实现，始终返回不可刷新。
class NoopAuthRefresher implements AuthRefresher {
  @override
  Future<RefreshedToken?> refreshToken({String? refreshToken}) async => null;
}
