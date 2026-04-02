import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foundation/foundation.dart';
import 'package:module_profile/src/application/usecases/load_profile_use_case.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  资料加载用例测试，验证可按配置生成正确资料摘要。

void main() {
  test('returns summary based on app config', () {
    final useCase = LoadProfileUseCase(
      appConfig: const AppConfig(
        appName: 'Consumer',
        env: AppEnv.dev,
        apiConfig: ApiConfig(baseUrl: 'https://example.com'),
        featureFlags: FeatureFlags(
          enablePayment: true,
          enableSubscription: true,
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
        enabledModules: <String>[
          'module_auth',
          'module_home',
          'module_profile',
        ],
      ),
    );

    final summary = useCase.execute();

    expect(summary.brandName, 'Life Consumer');
    expect(summary.featureCount, 2);
  });
}
