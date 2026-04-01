import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foundation/foundation.dart';
import 'package:module_home/src/application/usecases/load_home_entries_use_case.dart';

void main() {
  test('contains profile marker when profile module is enabled', () {
    final useCase = LoadHomeEntriesUseCase(
      appConfig: const AppConfig(
        appName: 'Consumer',
        env: AppEnv.dev,
        apiConfig: ApiConfig(baseUrl: 'https://example.com'),
        featureFlags: FeatureFlags(
          enablePayment: true,
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
      ),
    );

    final entries = useCase.execute();

    expect(entries.any((e) => e.title == 'Profile Module'), isTrue);
  });
}
