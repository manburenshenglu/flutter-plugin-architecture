#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: tooling/create_module.sh <module_name>"
  echo "Example: tooling/create_module.sh module_orders"
  exit 1
fi

MODULE_NAME="$1"
MODULE_DIR="packages/modules/${MODULE_NAME}"

if [[ ! "$MODULE_NAME" =~ ^module_[a-z0-9_]+$ ]]; then
  echo "Error: module name must match module_<snake_case>"
  exit 1
fi

if [ -d "$MODULE_DIR" ]; then
  echo "Error: $MODULE_DIR already exists"
  exit 1
fi

suffix="${MODULE_NAME#module_}"
class_suffix=$(echo "$suffix" | awk -F'_' '{for(i=1;i<=NF;i++){printf toupper(substr($i,1,1)) substr($i,2)} }')
module_class="Module${class_suffix}"
controller_class="${class_suffix}Controller"
page_class="${class_suffix}Page"
usecase_class="Load${class_suffix}UseCase"
entity_class="${class_suffix}Entry"

flutter create --template=package --project-name "$MODULE_NAME" --org com.example "$MODULE_DIR"

mkdir -p "$MODULE_DIR/lib/src/application/usecases" \
  "$MODULE_DIR/lib/src/domain/entities" \
  "$MODULE_DIR/lib/src/presentation/controllers" \
  "$MODULE_DIR/lib/src/presentation/pages"

cat > "$MODULE_DIR/pubspec.yaml" <<PUBSPEC
name: ${MODULE_NAME}
description: ${MODULE_NAME} business module.
version: 0.1.0
publish_to: none

environment:
  sdk: ">=3.8.0 <4.0.0"
  flutter: ">=3.35.0"

dependencies:
  flutter:
    sdk: flutter
  get: ^4.7.2
  get_it: ^8.2.0
  foundation:
    path: ../../foundation
  design_system:
    path: ../../design_system
  shared:
    path: ../../shared

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
PUBSPEC

cat > "$MODULE_DIR/lib/${MODULE_NAME}.dart" <<DART
export 'src/${MODULE_NAME}_module.dart';
DART

cat > "$MODULE_DIR/lib/src/${MODULE_NAME}_module.dart" <<DART
import 'package:foundation/foundation.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';

import 'application/usecases/${usecase_class}.dart';
import 'presentation/controllers/${controller_class}.dart';
import 'presentation/pages/${page_class}.dart';

class ${module_class} implements AppModule {
  @override
  String get moduleName => '${MODULE_NAME}';

  @override
  ModuleDescriptor get descriptor => const ModuleDescriptor(
        moduleName: '${MODULE_NAME}',
        version: '0.1.0',
      );

  @override
  List<GetPage<dynamic>> get pages => [
        GetPage<dynamic>(
          name: '/${suffix}',
          page: () => const ${page_class}(),
          binding: BindingsBuilder(
            () {
              final sl = serviceLocator;
              Get.lazyPut<${controller_class}>(
                () => ${controller_class}(
                  appConfig: sl<AppConfig>(),
                  useCase: sl<${usecase_class}>(),
                ),
              );
            },
          ),
        ),
      ];

  @override
  void registerDependencies(GetIt sl, AppConfig config) {
    if (!sl.isRegistered<${usecase_class}>()) {
      sl.registerFactory<${usecase_class}>(() => ${usecase_class}(config));
    }
  }

  @override
  Future<void> initialize(AppConfig config) async {}
}
DART

cat > "$MODULE_DIR/lib/src/domain/entities/${entity_class}.dart" <<DART
class ${entity_class} {
  const ${entity_class}({required this.title});

  final String title;
}
DART

cat > "$MODULE_DIR/lib/src/application/usecases/${usecase_class}.dart" <<DART
import 'package:foundation/foundation.dart';

import '../../domain/entities/${entity_class}.dart';

class ${usecase_class} {
  ${usecase_class}(this._config);

  final AppConfig _config;

  List<${entity_class}> execute() {
    return <${entity_class}>[
      ${entity_class}(title: '${MODULE_NAME} in \\${_config.appName}'),
    ];
  }
}
DART

cat > "$MODULE_DIR/lib/src/presentation/controllers/${controller_class}.dart" <<DART
import 'package:foundation/foundation.dart';
import 'package:get/get.dart';

import '../../application/usecases/${usecase_class}.dart';
import '../../domain/entities/${entity_class}.dart';

class ${controller_class} extends GetxController {
  ${controller_class}({required this.appConfig, required ${usecase_class} useCase})
      : _useCase = useCase;

  final AppConfig appConfig;
  final ${usecase_class} _useCase;

  final RxList<${entity_class}> entries = <${entity_class}>[].obs;

  @override
  void onInit() {
    entries.assignAll(_useCase.execute());
    super.onInit();
  }
}
DART

cat > "$MODULE_DIR/lib/src/presentation/pages/${page_class}.dart" <<DART
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/${controller_class}.dart';

class ${page_class} extends StatelessWidget {
  const ${page_class}({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<${controller_class}>();

    return AppPageScaffold(
      title: '${class_suffix}',
      child: Obx(
        () => ListView.builder(
          itemCount: controller.entries.length,
          itemBuilder: (context, index) {
            final item = controller.entries[index];
            return ListTile(title: Text(item.title));
          },
        ),
      ),
    );
  }
}
DART

cat > "$MODULE_DIR/test/${MODULE_NAME}_test.dart" <<DART
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('placeholder', () {
    expect(true, isTrue);
  });
}
DART

echo "Created module skeleton: $MODULE_DIR"
