import 'package:flutter/material.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  通用页面骨架组件，统一 AppBar、边距与安全区布局。

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}
