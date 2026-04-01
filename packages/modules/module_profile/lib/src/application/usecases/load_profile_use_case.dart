import 'package:foundation/foundation.dart';

import '../../domain/entities/profile_summary.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  资料加载用例，基于应用配置计算资料摘要数据。

class LoadProfileUseCase {
  LoadProfileUseCase({required AppConfig appConfig}) : _appConfig = appConfig;

  final AppConfig _appConfig;

  ProfileSummary execute() {
    final flags = _appConfig.featureFlags;
    var enabled = 0;
    if (flags.enablePayment) enabled++;
    if (flags.enableSubscription) enabled++;
    if (flags.enableMedication) enabled++;
    if (flags.enableDietarySupplements) enabled++;

    return ProfileSummary(
      brandName: _appConfig.brandConfig.brandName,
      analyticsProvider: _appConfig.analyticsConfig.provider,
      featureCount: enabled,
    );
  }
}
