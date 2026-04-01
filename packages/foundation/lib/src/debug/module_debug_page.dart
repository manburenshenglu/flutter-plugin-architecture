import 'package:flutter/material.dart';

import '../app_bootstrap/capability/capability_registry.dart';
import '../app_bootstrap/module_registry.dart';
import '../app_config/app_config.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  模块调试页，集中展示配置、模块、路由与能力注册信息。

class ModuleDebugPage extends StatelessWidget {
  const ModuleDebugPage({
    super.key,
    required this.config,
    required this.registry,
    required this.capabilityRegistry,
  });

  final AppConfig config;
  final ModuleRegistry registry;
  final CapabilityRegistry capabilityRegistry;

  @override
  Widget build(BuildContext context) {
    final moduleNames = registry.collectModuleNames();
    final descriptors = registry.collectDescriptors();
    final routeNames = registry
        .collectPages()
        .map((page) => page.name)
        .toList();
    final capabilityNames = capabilityRegistry.listCapabilityNames();
    final warnings = capabilityRegistry.listWarnings();

    return Scaffold(
      appBar: AppBar(title: const Text('Module Debug')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'App Config',
            items: <String>[
              'App: ${config.appName}',
              'Brand: ${config.brandConfig.brandName}',
              'Env: ${config.env.name}',
              'API: ${config.apiConfig.baseUrl}',
            ],
          ),
          _Section(title: 'Enabled Modules', items: moduleNames),
          _Section(
            title: 'Module Descriptors',
            items: descriptors
                .map(
                  (d) =>
                      '${d.moduleName}@${d.version} deps: '
                      '${d.dependencies.map((dep) => dep.moduleName).join(', ')}',
                )
                .toList(),
          ),
          _Section(title: 'Registered Routes', items: routeNames),
          _Section(title: 'Capabilities', items: capabilityNames),
          _Section(title: 'Startup Warnings', items: warnings),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Text('None')
            else
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('- $item'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
