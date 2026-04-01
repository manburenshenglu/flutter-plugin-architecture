import 'package:flutter/material.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  通用文本输入组件，封装基础输入框与密码模式。

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(labelText: label),
    );
  }
}
