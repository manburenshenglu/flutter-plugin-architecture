import 'app_module.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  按启用模块清单从模块目录中筛选并返回实际加载模块。

class ModuleSelector {
  const ModuleSelector._();

  static List<AppModule> select({
    required Map<String, AppModule> catalog,
    required List<String> enabledModules,
  }) {
    return enabledModules
        .where(catalog.containsKey)
        .map((moduleName) => catalog[moduleName]!)
        .toList(growable: false);
  }
}
