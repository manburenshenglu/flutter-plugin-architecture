import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foundation/foundation.dart';
import 'package:module_home/src/application/usecases/load_home_entries_use_case.dart';
import 'package:module_home/src/presentation/controllers/home_controller.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  首页控制器测试，验证初始化会加载数据并暴露 profile 可用状态。

void main() {
  test('loads entries on init and exposes profile availability', () {
    const config = AppConfig(
      appName: 'Consumer',
      env: AppEnv.dev,
      apiConfig: ApiConfig(baseUrl: 'https://example.com'),
      featureFlags: FeatureFlags(
        enablePayment: false,
        enableSubscription: false,
        enableMedication: false,
        enableDietarySupplements: false,
      ),
      analyticsConfig: AnalyticsConfig(enabled: true, provider: 'firebase'),
      brandConfig: BrandConfig(
        brandId: 'consumer',
        brandName: 'Life Consumer',
        seedColor: Colors.blue,
      ),
      enabledModules: <String>['module_auth', 'module_home', 'module_profile'],
    );

    final controller = HomeController(
      appConfig: config,
      loadHomeEntriesUseCase: LoadHomeEntriesUseCase(appConfig: config),
    )..onInit();

    expect(controller.entries, isNotEmpty);
    expect(controller.canOpenProfile, isTrue);
  });
}
