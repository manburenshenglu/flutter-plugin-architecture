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
