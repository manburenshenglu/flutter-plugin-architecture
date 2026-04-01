import 'package:flutter/material.dart';

abstract final class AppTokens {
  static const double spacingXs = 8;
  static const double spacingSm = 12;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double radiusMd = 12;
  static const double radiusLg = 18;

  static const Duration fastMotion = Duration(milliseconds: 180);
  static const Duration normalMotion = Duration(milliseconds: 260);

  static const TextStyle titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
}
