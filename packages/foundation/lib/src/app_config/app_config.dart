import 'analytics_config.dart';
import 'api_config.dart';
import 'app_env.dart';
import 'brand_config.dart';
import 'feature_flags.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  应用聚合配置模型，集中管理环境、品牌、接口、模块与开关信息。

class AppConfig {
  const AppConfig({
    required this.appName,
    required this.env,
    required this.apiConfig,
    required this.featureFlags,
    required this.analyticsConfig,
    required this.brandConfig,
    required this.enabledModules,
  });

  final String appName;
  final AppEnv env;
  final ApiConfig apiConfig;
  final FeatureFlags featureFlags;
  final AnalyticsConfig analyticsConfig;
  final BrandConfig brandConfig;
  final List<String> enabledModules;
}
