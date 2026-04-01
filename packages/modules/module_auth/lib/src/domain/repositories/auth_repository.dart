/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  认证仓储接口，定义账号密码登录能力。

abstract class AuthRepository {
  Future<bool> login({required String account, required String password});
}
