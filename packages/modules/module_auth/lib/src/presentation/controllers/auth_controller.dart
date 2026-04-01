import 'package:foundation/foundation.dart';
import 'package:get/get.dart';
import 'package:shared/shared.dart';

import '../../application/usecases/login_use_case.dart';
import '../../application/services/auth_session_service.dart';

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
