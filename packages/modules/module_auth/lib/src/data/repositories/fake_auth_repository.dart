import '../../domain/repositories/auth_repository.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  认证仓储的示例实现，模拟异步登录并返回基础校验结果。

class FakeAuthRepository implements AuthRepository {
  @override
  Future<bool> login({
    required String account,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return account.isNotEmpty && password.isNotEmpty;
  }
}
