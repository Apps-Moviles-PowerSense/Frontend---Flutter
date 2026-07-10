class DashboardKPIs {
  final int totalDevices;
  final int activeDevices;
  final double totalConsumption;
  final double totalCost;
  final int efficiency;
  final double monthlySavings;
  final double estimatedCost;
  final int consumptionVariation;
  final int costVariation;
  final int efficiencyVariation;

  DashboardKPIs({
    required this.totalDevices, required this.activeDevices, required this.totalConsumption,
    required this.totalCost, required this.efficiency, required this.monthlySavings,
    required this.estimatedCost, required this.consumptionVariation, required this.costVariation,
    required this.efficiencyVariation,
  });
}
