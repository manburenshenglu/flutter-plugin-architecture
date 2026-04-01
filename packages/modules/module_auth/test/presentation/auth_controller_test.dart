import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foundation/foundation.dart';
import 'package:get/get.dart';
import 'package:module_auth/src/application/services/auth_session_service.dart';
import 'package:module_auth/src/application/usecases/login_use_case.dart';
import 'package:module_auth/src/domain/repositories/auth_repository.dart';
import 'package:module_auth/src/presentation/controllers/auth_controller.dart';

class _FailAuthRepository implements AuthRepository {
  @override
  Future<bool> login({
    required String account,
    required String password,
  }) async {
    return false;
  }
}

void main() {
  test('sets error message when login fails', () async {
    Get.testMode = true;

    final controller = AuthController(
      loginUseCase: LoginUseCase(_FailAuthRepository()),
      appConfig: const AppConfig(
        appName: 'T',
        env: AppEnv.dev,
        apiConfig: ApiConfig(baseUrl: 'https://example.com'),
        featureFlags: FeatureFlags(
          enablePayment: false,
          enableSubscription: false,
          enableMedication: false,
          enableDietarySupplements: false,
        ),
        analyticsConfig: AnalyticsConfig(enabled: false, provider: 'none'),
        brandConfig: BrandConfig(
          brandId: 't',
          brandName: 'Test',
          seedColor: Colors.blue,
        ),
        enabledModules: <String>['module_auth'],
      ),
      authSessionService: AuthSessionService(),
    );

    await controller.login(account: 'a', password: 'b');

    expect(controller.isLoading.value, isFalse);
    expect(controller.errorMessage.value.isNotEmpty, isTrue);
  });
}
