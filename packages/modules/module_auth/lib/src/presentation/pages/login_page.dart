import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  登录页面入口组件，承载账号密码输入与登录动作。

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return AppPageScaffold(
      title: 'Login',
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome to ${controller.appConfig.appName}'),
            const SizedBox(height: 16),
            AppTextField(controller: _accountController, label: 'Account'),
            const SizedBox(height: 12),
            AppTextField(
              controller: _passwordController,
              label: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Login',
              isLoading: controller.isLoading.value,
              onPressed: () => controller.login(
                account: _accountController.text,
                password: _passwordController.text,
              ),
            ),
            const SizedBox(height: 12),
            if (controller.errorMessage.value.isNotEmpty)
              Text(
                controller.errorMessage.value,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      ),
    );
  }
}
