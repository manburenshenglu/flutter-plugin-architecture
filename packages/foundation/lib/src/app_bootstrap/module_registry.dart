import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../app_config/app_config.dart';
import 'app_module.dart';
import 'capability/capability_registry.dart';
import 'capability/module_capability_provider.dart';
import 'module_descriptor.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  模块注册中心，负责依赖校验、模块初始化和路由汇总。

class ModuleRegistry {
  ModuleRegistry({required List<AppModule> modules}) : _modules = modules;

  final List<AppModule> _modules;

  List<GetPage<dynamic>> collectPages() {
    return _modules.expand((module) => module.pages).toList(growable: false);
  }

  List<String> collectModuleNames() {
    return _modules.map((module) => module.moduleName).toList(growable: false);
  }

  List<ModuleDescriptor> collectDescriptors() {
    return _modules.map((module) => module.descriptor).toList(growable: false);
  }

  Future<void> registerAll(
    GetIt sl,
    AppConfig config,
    CapabilityRegistry capabilityRegistry,
  ) async {
    _validateDependencies();

    for (final module in _modules) {
      module.registerDependencies(sl, config);
      await module.initialize(config);
      if (module is ModuleCapabilityProvider) {
        capabilityRegistry.enterModule(module.moduleName);
        (module as ModuleCapabilityProvider).registerCapabilities(
          capabilityRegistry,
          sl,
          config,
        );
      }
    }
  }

  void _validateDependencies() {
    final installed = collectModuleNames().toSet();
    for (final module in _modules) {
      for (final dep in module.descriptor.dependencies) {
        if (!installed.contains(dep.moduleName)) {
          throw StateError(
            'Module ${module.moduleName} requires ${dep.moduleName} '
            '(${dep.versionConstraint}), but it is not enabled.',
          );
        }
      }
    }
  }
}
