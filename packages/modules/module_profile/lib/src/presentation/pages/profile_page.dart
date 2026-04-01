import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return AppPageScaffold(
      title: 'Profile',
      child: Obx(() {
        final data = controller.summary.value;
        if (data == null) {
          return const Center(child: AppLoading(message: 'Loading profile...'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Brand: ${data.brandName}'),
            const SizedBox(height: 8),
            Text('Analytics: ${data.analyticsProvider}'),
            const SizedBox(height: 8),
            Text('Enabled feature count: ${data.featureCount}'),
          ],
        );
      }),
    );
  }
}
