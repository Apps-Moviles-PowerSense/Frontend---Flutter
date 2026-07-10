class ReportKPIs {
  final double totalConsumption;
  final double totalCost;
  final int efficiency;
  final int consumptionVariation;
  final int costVariation;
  final int efficiencyVariation;

  ReportKPIs({
    required this.totalConsumption,
    required this.totalCost,
    required this.efficiency,
    required this.consumptionVariation,
    required this.costVariation,
    required this.efficiencyVariation,
  });
}

class MonthlyComparison {
  final String month;
  final double value1;
  final double value2;

  MonthlyComparison({
    required this.month,
    required this.value1,
    required this.value2,
  });
}

class DepartmentMetric {
  final String department;
  final double current;
  final double previous;

  DepartmentMetric({
    required this.department,
    required this.current,
    required this.previous,
  });
}

class ReportHistory {
  final String id;
  final String period;
  final String department;
  final double consumption;
  final double cost;
  final int variation;

  ReportHistory({
    this.id = "",
    required this.period,
    required this.department,
    required this.consumption,
    required this.cost,
    required this.variation,
  });
}

class RealtimeConsumption {
  final String period;
  final String label;
  final double consumption;

  RealtimeConsumption({
    required this.period,
    required this.label,
    required this.consumption,
  });
}