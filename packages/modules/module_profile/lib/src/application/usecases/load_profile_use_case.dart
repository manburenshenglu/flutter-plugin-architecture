import 'package:foundation/foundation.dart';

import '../../domain/entities/profile_summary.dart';

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
