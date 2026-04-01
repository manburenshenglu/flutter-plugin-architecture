import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../app_config/app_config.dart';
import 'module_descriptor.dart';

abstract class AppModule {
  String get moduleName;

  ModuleDescriptor get descriptor;

  List<GetPage<dynamic>> get pages;

  void registerDependencies(GetIt sl, AppConfig config);

  Future<void> initialize(AppConfig config) async {}
}
