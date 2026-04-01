import 'package:foundation/foundation.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';

import 'application/usecases/load_home_entries_use_case.dart';
import 'presentation/controllers/home_controller.dart';
import 'presentation/pages/home_page.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  首页业务模块，负责首页路由声明与首页相关依赖注册。

class ModuleHome implements AppModule {
  @override
  String get moduleName => 'module_home';

  @override
  ModuleDescriptor get descriptor => const ModuleDescriptor(
    moduleName: 'module_home',
    version: '0.1.0',
    dependencies: <ModuleDependency>[
      ModuleDependency(moduleName: 'module_auth', versionConstraint: '>=0.1.0'),
    ],
  );

  @override
  List<GetPage<dynamic>> get pages => [
    GetPage<dynamic>(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: BindingsBuilder(() {
        final sl = serviceLocator;
        Get.lazyPut<HomeController>(
          () => HomeController(
            appConfig: sl<AppConfig>(),
            loadHomeEntriesUseCase: sl<LoadHomeEntriesUseCase>(),
          ),
        );
      }),
    ),
  ];

  @override
  void registerDependencies(GetIt sl, AppConfig config) {
    if (!sl.isRegistered<LoadHomeEntriesUseCase>()) {
      sl.registerFactory<LoadHomeEntriesUseCase>(
        () => LoadHomeEntriesUseCase(appConfig: sl<AppConfig>()),
      );
    }
  }

  @override
  Future<void> initialize(AppConfig config) async {}
}
