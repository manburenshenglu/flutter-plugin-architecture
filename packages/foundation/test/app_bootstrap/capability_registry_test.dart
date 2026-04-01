import 'package:flutter_test/flutter_test.dart';
import 'package:foundation/foundation.dart';

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
