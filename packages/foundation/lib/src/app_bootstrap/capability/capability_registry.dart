/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  能力注册中心，负责能力登记、查询及重复注册告警记录。

class CapabilityRegistry {
  final Map<Type, Object> _capabilities = <Type, Object>{};
  final Map<Type, String> _capabilityOwners = <Type, String>{};
  final List<String> _warnings = <String>[];
  String _currentModule = 'unknown';

  void enterModule(String moduleName) {
    _currentModule = moduleName;
  }

  void register<T extends Object>(T capability) {
    if (_capabilities.containsKey(T)) {
      final owner = _capabilityOwners[T] ?? 'unknown';
      _warnings.add(
        'Capability $T already registered by $owner; duplicate ignored from $_currentModule.',
      );
      return;
    }
    _capabilities[T] = capability;
    _capabilityOwners[T] = _currentModule;
  }

  T? tryGet<T extends Object>() {
    final capability = _capabilities[T];
    if (capability == null) {
      return null;
    }
    return capability as T;
  }

  T require<T extends Object>() {
    final capability = tryGet<T>();
    if (capability == null) {
      throw StateError('Capability $T is not registered.');
    }
    return capability;
  }

  List<String> listCapabilityNames() {
    return _capabilities.keys
        .map((type) => type.toString())
        .toList(growable: false);
  }

  List<String> listWarnings() {
    return List<String>.unmodifiable(_warnings);
  }
}
