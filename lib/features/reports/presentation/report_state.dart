import 'package:power_sense/features/reports/domain/report.dart';

abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportSuccess extends ReportState {
  final ReportKPIs kpis;
  final List<MonthlyComparison> monthlyComparison;
  final List<DepartmentMetric> departmentsMetrics;
  final List<ReportHistory> history;
  final List<RealtimeConsumption> realtimeConsumption;

  ReportSuccess({
    required this.kpis,
    required this.monthlyComparison,
    required this.departmentsMetrics,
    required this.history,
    required this.realtimeConsumption,
  });
}

class ReportFailure extends ReportState {
  final String message;

  ReportFailure({required this.message});
}