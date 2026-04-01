import 'package:brands/brands.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
import 'package:get/get.dart';
import 'package:module_auth/module_auth.dart';
import 'package:module_home/module_home.dart';
import 'package:module_profile/module_profile.dart';
import 'package:shared/shared.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = BrandProfiles.consumer(env: AppEnv.dev);
  final moduleCatalog = <String, AppModule>{
    'module_auth': ModuleAuth(),
    'module_home': ModuleHome(),
    'module_profile': ModuleProfile(),
  };
  final modules = ModuleSelector.select(
    catalog: moduleCatalog,
    enabledModules: config.enabledModules,
  );

  final registry = await AppBootstrapper.bootstrap(
    config: config,
    modules: modules,
  );

  runApp(_AppRoot(config: config, pages: registry.collectPages()));
}

class _AppRoot extends StatelessWidget {
  const _AppRoot({required this.config, required this.pages});

  final AppConfig config;
  final List<GetPage<dynamic>> pages;

  @override
  Widget build(BuildContext context) {
    final debugPage = GetPage<dynamic>(
      name: AppRoutes.debugModules,
      page: () => ModuleDebugPage(
        config: config,
        registry: serviceLocator<ModuleRegistry>(),
        capabilityRegistry: serviceLocator<CapabilityRegistry>(),
      ),
    );

    return GetMaterialApp(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      theme: AppThemeFactory.light(config.brandConfig),
      initialRoute: AppRoutes.authLogin,
      getPages: <GetPage<dynamic>>[...pages, debugPage],
    );
  }
}
