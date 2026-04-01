import '../../domain/repositories/auth_repository.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  登录用例，封装登录业务调用并委托认证仓储执行。

class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<bool> execute({required String account, required String password}) {
    return _repository.login(account: account, password: password);
  }
}
