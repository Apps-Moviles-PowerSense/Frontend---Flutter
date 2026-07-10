import 'package:power_sense/features/reports/domain/report.dart';

class ReportKPIsDto {
  final double totalConsumptionKWh;
  final double totalCostUSD;
  final int efficiencyPct;
  final int consumptionPct;
  final int costPct;
  final int efficiencyPctComparison;

  ReportKPIsDto({
    required this.totalConsumptionKWh,
    required this.totalCostUSD,
    required this.efficiencyPct,
    required this.consumptionPct,
    required this.costPct,
    required this.efficiencyPctComparison,
  });

  factory ReportKPIsDto.fromJson(Map<String, dynamic> json) {
    final comparison = json['comparison'] as Map<String, dynamic>? ?? {};
    
    return ReportKPIsDto(
      totalConsumptionKWh: (json['totalConsumptionKWh'] as num?)?.toDouble() ?? 0.0,
      totalCostUSD: (json['totalCostUSD'] as num?)?.toDouble() ?? 0.0,
      efficiencyPct: (json['efficiencyPct'] as num?)?.toInt() ?? 0,
      consumptionPct: (comparison['consumptionPct'] as num?)?.toInt() ?? 0,
      costPct: (comparison['costPct'] as num?)?.toInt() ?? 0,
      efficiencyPctComparison: (comparison['efficiencyPct'] as num?)?.toInt() ?? 0,
    );
  }

  ReportKPIs toDomain() {
    return ReportKPIs(
      totalConsumption: totalConsumptionKWh,
      totalCost: totalCostUSD,
      efficiency: efficiencyPct,
      consumptionVariation: consumptionPct,
      costVariation: costPct,
      efficiencyVariation: efficiencyPctComparison,
    );
  }
}

class MonthlyComparisonDto {
  final String month;
  final double value1;
  final double value2;

  MonthlyComparisonDto({required this.month, required this.value1, required this.value2});

  factory MonthlyComparisonDto.fromJson(Map<String, dynamic> json) {
    return MonthlyComparisonDto(
      month: json['month'] ?? '',
      value1: (json['value1'] as num?)?.toDouble() ?? 0.0,
      value2: (json['value2'] as num?)?.toDouble() ?? 0.0,
    );
  }

  MonthlyComparison toDomain() {
    return MonthlyComparison(month: month, value1: value1, value2: value2);
  }
}

class DepartmentMetricDto {
  final String department;
  final double current;
  final double previous;

  DepartmentMetricDto({required this.department, required this.current, required this.previous});

  factory DepartmentMetricDto.fromJson(Map<String, dynamic> json) {
    return DepartmentMetricDto(
      department: json['department'] ?? '',
      current: (json['current'] as num?)?.toDouble() ?? 0.0,
      previous: (json['previous'] as num?)?.toDouble() ?? 0.0,
    );
  }

  DepartmentMetric toDomain() {
    return DepartmentMetric(department: department, current: current, previous: previous);
  }
}

class ReportHistoryDto {
  final String id;
  final String period;
  final String department;
  final double consumption;
  final double cost;
  final int variation;

  ReportHistoryDto({
    required this.id, required this.period, required this.department,
    required this.consumption, required this.cost, required this.variation
  });

  factory ReportHistoryDto.fromJson(Map<String, dynamic> json) {
    return ReportHistoryDto(
      id: json['id'] ?? '',
      period: json['period'] ?? '',
      department: json['department'] ?? '',
      consumption: (json['consumption'] as num?)?.toDouble() ?? 0.0,
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      variation: (json['variation'] as num?)?.toInt() ?? 0,
    );
  }

  ReportHistory toDomain() {
    return ReportHistory(
      id: id, period: period, department: department,
      consumption: consumption, cost: cost, variation: variation
    );
  }
}

class RealtimeConsumptionDto {
  final String period;
  final String label;
  final double consumption;

  RealtimeConsumptionDto({required this.period, required this.label, required this.consumption});

  factory RealtimeConsumptionDto.fromJson(Map<String, dynamic> json) {
    return RealtimeConsumptionDto(
      period: json['period'] ?? '',
      label: json['label'] ?? '',
      consumption: (json['consumption'] as num?)?.toDouble() ?? 0.0,
    );
  }

  RealtimeConsumption toDomain() {
    return RealtimeConsumption(period: period, label: label, consumption: consumption);
  }
}