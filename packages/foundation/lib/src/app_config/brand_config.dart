import 'package:flutter/material.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  品牌配置模型，定义品牌标识、名称与主题种子色。

class BrandConfig {
  const BrandConfig({
    required this.brandId,
    required this.brandName,
    required this.seedColor,
  });

  final String brandId;
  final String brandName;
  final Color seedColor;
}
