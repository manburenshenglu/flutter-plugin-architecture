import 'package:foundation/foundation.dart';

import '../../domain/entities/home_entry.dart';

class LoadHomeEntriesUseCase {
  LoadHomeEntriesUseCase({required AppConfig appConfig})
    : _appConfig = appConfig;

  final AppConfig _appConfig;

  List<HomeEntry> execute() {
    final flags = _appConfig.featureFlags;

    final entries = <HomeEntry>[
      HomeEntry(
        title: _appConfig.brandConfig.brandName,
        description: 'Environment: ${_appConfig.env.name}',
      ),
      HomeEntry(title: 'API', description: _appConfig.apiConfig.baseUrl),
    ];

    if (flags.enablePayment) {
      entries.add(const HomeEntry(title: 'Payment', description: 'Enabled'));
    }
    if (flags.enableSubscription) {
      entries.add(
        const HomeEntry(title: 'Subscription', description: 'Enabled'),
      );
    }
    if (flags.enableMedication) {
      entries.add(const HomeEntry(title: 'Medication', description: 'Enabled'));
    }
    if (flags.enableDietarySupplements) {
      entries.add(
        const HomeEntry(title: 'Dietary Supplements', description: 'Enabled'),
      );
    }
    if (_appConfig.enabledModules.contains('module_profile')) {
      entries.add(
        const HomeEntry(title: 'Profile Module', description: 'Enabled'),
      );
    }

    return entries;
  }
}
