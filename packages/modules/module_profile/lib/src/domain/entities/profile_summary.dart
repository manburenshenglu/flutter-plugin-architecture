/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  个人资料摘要实体，承载资料页展示所需聚合信息。

class ProfileSummary {
  const ProfileSummary({
    required this.brandName,
    required this.analyticsProvider,
    required this.featureCount,
  });

  final String brandName;
  final String analyticsProvider;
  final int featureCount;
}
