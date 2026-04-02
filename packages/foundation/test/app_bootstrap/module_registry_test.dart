import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foundation/foundation.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  测试用模块桩实现，用于构造模块依赖校验场景。

class _FakeModule implements AppModule {
  _FakeModule({required this.name, required this.descriptorValue});

  final String name;
  final ModuleDescriptor descriptorValue;

  @override
  ModuleDescriptor get descriptor => descriptorValue;

  @override
  String get moduleName => name;

  @override
  List<GetPage<dynamic>> get pages => const <GetPage<dynamic>>[];

  @override
  Future<void> initialize(AppConfig config) async {}

  @override
  void registerDependencies(GetIt sl, AppConfig config) {}
}

void main() {
  test('throws when required module dependency is missing', () async {
    final registry = ModuleRegistry(
      modules: <AppModule>[
        _FakeModule(
          name: 'module_home',
          descriptorValue: const ModuleDescriptor(
            moduleName: 'module_home',
            version: '0.1.0',
            dependencies: <ModuleDependency>[
              ModuleDependency(
                moduleName: 'module_auth',
                versionConstraint: '>=0.1.0',
              ),
            ],
          ),
        ),
      ],
    );

    expect(
      () => registry.registerAll(
        GetIt.asNewInstance(),
        const AppConfig(
          appName: 'Test',
          env: AppEnv.dev,
          apiConfig: ApiConfig(baseUrl: 'https://example.com'),
          featureFlags: FeatureFlags(
            enablePayment: false,
            enableSubscription: false,
            enableMedication: false,
            enableDietarySupplements: false,
            useXmlLoginApi: false,
          ),
          analyticsConfig: AnalyticsConfig(enabled: false, provider: 'none'),
          brandConfig: BrandConfig(
            brandId: 'test',
            brandName: 'Test',
            seedColor: Colors.blue,
          ),
          enabledModules: <String>['module_home'],
        ),
        CapabilityRegistry(),
      ),
      throwsA(isA<StateError>()),
    );
  });
}
