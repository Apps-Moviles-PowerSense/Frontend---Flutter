class DashboardKPIsResponse {
  final int totalDevices;
  final int activeDevices;
  final double totalConsumptionKWh;
  final double totalCostUSD;
  final int efficiencyPct;
  final double estimatedMonthlyCost;
  final double monthlySavings;
  final Map<String, dynamic> comparison;

  DashboardKPIsResponse({
    required this.totalDevices, required this.activeDevices, required this.totalConsumptionKWh,
    required this.totalCostUSD, required this.efficiencyPct, required this.estimatedMonthlyCost,
    required this.monthlySavings, required this.comparison,
  });

  factory DashboardKPIsResponse.fromJson(Map<String, dynamic> json) {
    return DashboardKPIsResponse(
      totalDevices: json['totalDevices'] ?? 0,
      activeDevices: json['activeDevices'] ?? 0,
      totalConsumptionKWh: (json['totalConsumptionKWh'] as num?)?.toDouble() ?? 0.0,
      totalCostUSD: (json['totalCostUSD'] as num?)?.toDouble() ?? 0.0,
      efficiencyPct: json['efficiencyPct'] ?? 0,
      estimatedMonthlyCost: (json['estimatedMonthlyCost'] as num?)?.toDouble() ?? 0.0,
      monthlySavings: (json['monthlySavings'] as num?)?.toDouble() ?? 0.0,
      comparison: json['comparison'] ?? {},
    );
  }
}
