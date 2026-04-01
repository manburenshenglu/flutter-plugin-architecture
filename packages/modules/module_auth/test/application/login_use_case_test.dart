import 'package:flutter_test/flutter_test.dart';
import 'package:module_auth/src/application/usecases/login_use_case.dart';
import 'package:module_auth/src/domain/repositories/auth_repository.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  测试用认证仓储桩，按预设结果返回登录结果。

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this.result);

  final bool result;

  @override
  Future<bool> login({
    required String account,
    required String password,
  }) async {
    return result;
  }
}

void main() {
  test('returns true when repository returns true', () async {
    final useCase = LoginUseCase(_FakeAuthRepository(true));

    final result = await useCase.execute(account: 'demo', password: '123456');

    expect(result, isTrue);
  });
}
