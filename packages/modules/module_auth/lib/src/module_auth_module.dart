import 'package:foundation/foundation.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';

import 'application/usecases/login_use_case.dart';
import 'application/services/auth_session_service.dart';
import 'data/repositories/fake_auth_repository.dart';
import 'domain/repositories/auth_repository.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/pages/login_page.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  认证业务模块，负责声明模块元数据、注册依赖、路由和会话能力。

class ModuleAuth implements AppModule, ModuleCapabilityProvider {
  @override
  String get moduleName => 'module_auth';

  @override
  ModuleDescriptor get descriptor => const ModuleDescriptor(
    moduleName: 'module_auth',
    version: '0.1.0',
    dependencies: <ModuleDependency>[],
    providedCapabilities: <String>['SessionReadable'],
  );

  @override
  List<GetPage<dynamic>> get pages => [
    GetPage<dynamic>(
      name: AppRoutes.authLogin,
      page: () => const LoginPage(),
      binding: BindingsBuilder(() {
        final sl = serviceLocator;
        Get.lazyPut<AuthController>(
          () => AuthController(
            loginUseCase: sl<LoginUseCase>(),
            appConfig: sl<AppConfig>(),
            authSessionService: sl<AuthSessionService>(),
          ),
        );
      }),
    ),
  ];

  @override
  void registerDependencies(GetIt sl, AppConfig config) {
    if (!sl.isRegistered<AuthSessionService>()) {
      sl.registerLazySingleton<AuthSessionService>(() => AuthSessionService());
    }
    if (!sl.isRegistered<AuthRepository>()) {
      sl.registerLazySingleton<AuthRepository>(() => FakeAuthRepository());
    }
    if (!sl.isRegistered<LoginUseCase>()) {
      sl.registerFactory<LoginUseCase>(
        () => LoginUseCase(sl<AuthRepository>()),
      );
    }
  }

  @override
  Future<void> initialize(AppConfig config) async {}

  @override
  void registerCapabilities(
    CapabilityRegistry registry,
    GetIt serviceLocator,
    AppConfig config,
  ) {
    registry.register<SessionReadable>(serviceLocator<AuthSessionService>());
  }
}
