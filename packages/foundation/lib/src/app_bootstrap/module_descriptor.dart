/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  模块依赖声明模型，描述依赖模块名与版本约束。

class ModuleDependency {
  const ModuleDependency({
    required this.moduleName,
    this.versionConstraint = 'any',
  });

  final String moduleName;
  final String versionConstraint;
}

class ModuleDescriptor {
  const ModuleDescriptor({
    required this.moduleName,
    required this.version,
    this.dependencies = const <ModuleDependency>[],
    this.providedCapabilities = const <String>[],
  });

  final String moduleName;
  final String version;
  final List<ModuleDependency> dependencies;
  final List<String> providedCapabilities;
}
