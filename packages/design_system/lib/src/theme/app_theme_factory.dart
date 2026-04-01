import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  根据品牌色生成全局 ThemeData，统一组件视觉风格。

class AppThemeFactory {
  const AppThemeFactory._();

  static ThemeData light(BrandConfig brand) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: brand.seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: colorScheme.surface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }
}
