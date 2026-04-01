import 'package:flutter_test/flutter_test.dart';
import 'package:foundation/foundation.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  测试用能力类型，占位用于验证能力重复注册告警。

class _CapA {
  const _CapA();
}

void main() {
  test('records warning when duplicate capability is registered', () {
    final registry = CapabilityRegistry();

    registry.enterModule('module_a');
    registry.register<_CapA>(const _CapA());

    registry.enterModule('module_b');
    registry.register<_CapA>(const _CapA());

    final warnings = registry.listWarnings();
    expect(warnings, isNotEmpty);
    expect(warnings.first.contains('duplicate ignored'), isTrue);
  });
}
