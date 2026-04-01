import 'package:get_it/get_it.dart';

import '../../app_config/app_config.dart';
import 'capability_registry.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  模块能力提供接口，约束模块向能力注册中心暴露能力的方式。

abstract class ModuleCapabilityProvider {
  void registerCapabilities(
    CapabilityRegistry registry,
    GetIt serviceLocator,
    AppConfig config,
  );
}
