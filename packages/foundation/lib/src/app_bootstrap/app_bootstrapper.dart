import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../app_config/app_config.dart';
import '../di/service_locator.dart';
import '../network/auth/auth_refresher.dart';
import '../network/auth/noop_auth_refresher.dart';
import '../network/auth/noop_unauthorized_handler.dart';
import '../network/auth/secure_token_store.dart';
import '../network/auth/token_store.dart';
import '../network/auth/unauthorized_handler.dart';
import '../network/dio_client_factory.dart';
import 'app_module.dart';
import 'capability/capability_registry.dart';
import 'module_registry.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  应用启动编排器，负责初始化核心依赖并完成模块注册。

class AppBootstrapper {
  AppBootstrapper._();

  static Future<ModuleRegistry> bootstrap({
    required AppConfig config,
    required List<AppModule> modules,
    TokenStore? tokenStore,
    AuthRefresher? authRefresher,
    UnauthorizedHandler? unauthorizedHandler,
    bool enableAutoRefresh = true,
  }) async {
    await _resetIfNeeded(serviceLocator);
    _registerCore(
      serviceLocator,
      config,
      tokenStore: tokenStore,
      authRefresher: authRefresher,
      unauthorizedHandler: unauthorizedHandler,
      enableAutoRefresh: enableAutoRefresh,
    );

    final capabilityRegistry = CapabilityRegistry();
    serviceLocator.registerSingleton<CapabilityRegistry>(capabilityRegistry);

    final registry = ModuleRegistry(modules: modules);
    await registry.registerAll(serviceLocator, config, capabilityRegistry);
    serviceLocator.registerSingleton<ModuleRegistry>(registry);
    return registry;
  }

  static void _registerCore(
    GetIt sl,
    AppConfig config, {
    TokenStore? tokenStore,
    AuthRefresher? authRefresher,
    UnauthorizedHandler? unauthorizedHandler,
    bool enableAutoRefresh = true,
  }) {
    sl.registerSingleton<AppConfig>(config);
    sl.registerLazySingleton<TokenStore>(
      () => tokenStore ?? SecureTokenStore(),
    );
    sl.registerLazySingleton<AuthRefresher>(
      () => authRefresher ?? NoopAuthRefresher(),
    );
    sl.registerLazySingleton<UnauthorizedHandler>(
      () => unauthorizedHandler ?? NoopUnauthorizedHandler(),
    );
    sl.registerLazySingleton<Dio>(
      () => DioClientFactory.create(
        config,
        tokenStore: sl<TokenStore>(),
        authRefresher: sl<AuthRefresher>(),
        unauthorizedHandler: sl<UnauthorizedHandler>(),
        enableAutoRefresh: enableAutoRefresh,
      ),
    );
  }

  static Future<void> _resetIfNeeded(GetIt sl) async {
    if (sl.isRegistered<AppConfig>()) {
      await sl.reset();
    }
  }
}
