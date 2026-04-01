import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../app_config/app_config.dart';
import '../di/service_locator.dart';
import 'app_module.dart';
import 'capability/capability_registry.dart';
import 'module_registry.dart';

class AppBootstrapper {
  AppBootstrapper._();

  static Future<ModuleRegistry> bootstrap({
    required AppConfig config,
    required List<AppModule> modules,
  }) async {
    await _resetIfNeeded(serviceLocator);
    _registerCore(serviceLocator, config);

    final capabilityRegistry = CapabilityRegistry();
    serviceLocator.registerSingleton<CapabilityRegistry>(capabilityRegistry);

    final registry = ModuleRegistry(modules: modules);
    await registry.registerAll(serviceLocator, config, capabilityRegistry);
    serviceLocator.registerSingleton<ModuleRegistry>(registry);
    return registry;
  }

  static void _registerCore(GetIt sl, AppConfig config) {
    sl.registerSingleton<AppConfig>(config);
    sl.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: config.apiConfig.baseUrl,
          connectTimeout: Duration(
            milliseconds: config.apiConfig.connectTimeoutMs,
          ),
        ),
      ),
    );
  }

  static Future<void> _resetIfNeeded(GetIt sl) async {
    if (sl.isRegistered<AppConfig>()) {
      await sl.reset();
    }
  }
}
