/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  功能开关配置模型，控制业务能力是否启用。

class FeatureFlags {
  const FeatureFlags({
    required this.enablePayment,
    required this.enableSubscription,
    required this.enableMedication,
    required this.enableDietarySupplements,
  });

  final bool enablePayment;
  final bool enableSubscription;
  final bool enableMedication;
  final bool enableDietarySupplements;
}
