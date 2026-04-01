import 'app_module.dart';

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
