import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  按品牌与环境生成应用配置，统一管理模块开关、品牌信息和 API 地址。

class BrandProfiles {
  const BrandProfiles._();

  /// app：consumer
  static AppConfig consumer({required AppEnv env}) {
    return AppConfig(
      appName: 'Consumer App',
      env: env,
      apiConfig: ApiConfig(baseUrl: _apiByEnv(env, consumer: true)),
      analyticsConfig: const AnalyticsConfig(
        enabled: true,
        provider: 'firebase',
      ),
      brandConfig: const BrandConfig(
        brandId: 'consumer',
        brandName: 'Life Consumer',
        seedColor: Color(0xFF1F7AE0),
      ),
      featureFlags: const FeatureFlags(
        enablePayment: true,
        enableSubscription: true,
        enableMedication: false,
        enableDietarySupplements: true,
        useXmlLoginApi: false,
      ),
      enabledModules: const <String>[
        'module_auth',
        'module_home',
        'module_profile',
      ],
    );
  }

  /// app：doctor
  static AppConfig doctor({required AppEnv env}) {
    return AppConfig(
      appName: 'Doctor App',
      env: env,
      apiConfig: ApiConfig(baseUrl: _apiByEnv(env, consumer: false)),
      analyticsConfig: const AnalyticsConfig(
        enabled: true,
        provider: 'mixpanel',
      ),
      brandConfig: const BrandConfig(
        brandId: 'doctor',
        brandName: 'Life Doctor',
        seedColor: Color(0xFF0B8F6A),
      ),
      featureFlags: const FeatureFlags(
        enablePayment: false,
        enableSubscription: false,
        enableMedication: true,
        enableDietarySupplements: false,
        useXmlLoginApi: false,
      ),
      enabledModules: const <String>['module_auth', 'module_home'],
    );
  }

  static String _apiByEnv(AppEnv env, {required bool consumer}) {
    switch (env) {
      case AppEnv.dev:
        return consumer
            ? 'https://dev-consumer.api.example.com'
            : 'https://dev-doctor.api.example.com';
      case AppEnv.staging:
        return consumer
            ? 'https://staging-consumer.api.example.com'
            : 'https://staging-doctor.api.example.com';
      case AppEnv.prod:
        return consumer
            ? 'https://consumer.api.example.com'
            : 'https://doctor.api.example.com';
    }
  }
}
