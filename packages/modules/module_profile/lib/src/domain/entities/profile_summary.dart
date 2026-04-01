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
