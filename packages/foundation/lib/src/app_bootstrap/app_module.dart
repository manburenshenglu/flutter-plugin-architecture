import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../app_config/app_config.dart';
import 'module_descriptor.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  模块统一接口，约束模块名称、描述、路由与依赖注册生命周期。

abstract class AppModule {
  String get moduleName;

  ModuleDescriptor get descriptor;

  List<GetPage<dynamic>> get pages;

  void registerDependencies(GetIt sl, AppConfig config);

  Future<void> initialize(AppConfig config) async {}
}
