import 'package:flutter/material.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  通用加载态组件，用于展示转圈和可选加载文案。

class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.message = 'Loading...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 12),
        Text(message),
      ],
    );
  }
}
