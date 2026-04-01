class FeatureFlags {
  const FeatureFlags({
    required this.enablePayment,
    required this.enableSubscription,
    required this.enableMedication,
    required this.enableDietarySupplements,
  });

  final bool enablePayment;
  final bool enableSubscription;
  final bool enableMedication;
  final bool enableDietarySupplements;
}
