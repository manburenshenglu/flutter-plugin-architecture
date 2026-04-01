import 'package:foundation/foundation.dart';
import 'package:get/get.dart';
import 'package:shared/shared.dart';

import '../../application/usecases/login_use_case.dart';
import '../../application/services/auth_session_service.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  登录流程控制器，负责提交登录、维护状态并处理登录后的路由跳转。

class AuthController extends GetxController {
  AuthController({
    required LoginUseCase loginUseCase,
    required this.appConfig,
    required AuthSessionService authSessionService,
  }) : _loginUseCase = loginUseCase,
       _authSessionService = authSessionService;

  final LoginUseCase _loginUseCase;
  final AuthSessionService _authSessionService;
  final AppConfig appConfig;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> login({
    required String account,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    final ok = await _loginUseCase.execute(
      account: account,
      password: password,
    );

    isLoading.value = false;
    if (ok) {
      _authSessionService.updateUserId(account);
      Get.offNamed(AppRoutes.home);
    } else {
      errorMessage.value = 'Login failed, please retry.';
    }
  }
}
