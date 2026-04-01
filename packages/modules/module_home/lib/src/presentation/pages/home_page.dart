import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared.dart';

import '../controllers/home_controller.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  首页展示组件，负责渲染入口卡片与页面跳转操作。

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return AppPageScaffold(
      title: 'Home',
      actions: [
        IconButton(
          onPressed: () => Get.toNamed(AppRoutes.debugModules),
          icon: const Icon(Icons.tune_rounded),
        ),
        if (controller.canOpenProfile)
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.profile),
            icon: const Icon(Icons.person_outline_rounded),
          ),
        IconButton(
          onPressed: () => Get.toNamed(AppRoutes.authLogin),
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
      child: Obx(
        () => ListView.separated(
          itemCount: controller.entries.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = controller.entries[index];
            return Card(
              child: ListTile(
                title: Text(item.title),
                subtitle: Text(item.description),
              ),
            );
          },
        ),
      ),
    );
  }
}
