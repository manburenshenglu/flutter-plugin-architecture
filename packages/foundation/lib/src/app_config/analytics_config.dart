/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  埋点配置模型，定义埋点是否启用及服务提供方。

class AnalyticsConfig {
  const AnalyticsConfig({required this.enabled, required this.provider});

  final bool enabled;
  final String provider;
}
