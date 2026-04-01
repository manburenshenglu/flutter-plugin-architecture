import 'package:get_it/get_it.dart';

import '../../app_config/app_config.dart';
import 'capability_registry.dart';

abstract class ModuleCapabilityProvider {
  void registerCapabilities(
    CapabilityRegistry registry,
    GetIt serviceLocator,
    AppConfig config,
  );
}
