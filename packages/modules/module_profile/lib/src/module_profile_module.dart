import 'package:foundation/foundation.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';

import 'application/services/profile_read_service.dart';
import 'application/usecases/load_profile_use_case.dart';
import 'presentation/controllers/profile_controller.dart';
import 'presentation/pages/profile_page.dart';

class ModuleProfile implements AppModule, ModuleCapabilityProvider {
  @override
  String get moduleName => 'module_profile';

  @override
  ModuleDescriptor get descriptor => const ModuleDescriptor(
    moduleName: 'module_profile',
    version: '0.1.0',
    dependencies: <ModuleDependency>[
      ModuleDependency(moduleName: 'module_auth', versionConstraint: '>=0.1.0'),
    ],
    providedCapabilities: <String>['ProfileReadable'],
  );

  @override
  List<GetPage<dynamic>> get pages => [
    GetPage<dynamic>(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: BindingsBuilder(() {
        final sl = serviceLocator;
        Get.lazyPut<ProfileController>(
          () => ProfileController(
            appConfig: sl<AppConfig>(),
            loadProfileUseCase: sl<LoadProfileUseCase>(),
          ),
        );
      }),
    ),
  ];

  @override
  void registerDependencies(GetIt sl, AppConfig config) {
    if (!sl.isRegistered<ProfileReadService>()) {
      sl.registerLazySingleton<ProfileReadService>(
        () => ProfileReadService(name: config.brandConfig.brandName),
      );
    }
    if (!sl.isRegistered<LoadProfileUseCase>()) {
      sl.registerFactory<LoadProfileUseCase>(
        () => LoadProfileUseCase(appConfig: sl<AppConfig>()),
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
    registry.register<ProfileReadable>(serviceLocator<ProfileReadService>());
  }
}
