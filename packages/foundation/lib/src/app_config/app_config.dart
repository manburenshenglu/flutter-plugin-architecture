import 'analytics_config.dart';
import 'api_config.dart';
import 'app_env.dart';
import 'brand_config.dart';
import 'feature_flags.dart';

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
