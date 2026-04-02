import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foundation/foundation.dart';
import 'package:module_profile/src/application/usecases/load_profile_use_case.dart';
import 'package:module_profile/src/presentation/controllers/profile_controller.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  资料控制器测试，验证初始化后可加载资料摘要。

void main() {
  test('loads profile summary on init', () {
    const config = AppConfig(
      appName: 'Consumer',
      env: AppEnv.dev,
      apiConfig: ApiConfig(baseUrl: 'https://example.com'),
      featureFlags: FeatureFlags(
        enablePayment: true,
        enableSubscription: false,
        enableMedication: false,
        enableDietarySupplements: false,
        useXmlLoginApi: false,
      ),
      analyticsConfig: AnalyticsConfig(enabled: true, provider: 'firebase'),
      brandConfig: BrandConfig(
        brandId: 'consumer',
        brandName: 'Life Consumer',
        seedColor: Colors.blue,
      ),
      enabledModules: <String>['module_auth', 'module_home', 'module_profile'],
    );

    final controller = ProfileController(
      appConfig: config,
      loadProfileUseCase: LoadProfileUseCase(appConfig: config),
    )..onInit();

    expect(controller.summary.value, isNotNull);
    expect(controller.summary.value?.brandName, 'Life Consumer');
  });
}
