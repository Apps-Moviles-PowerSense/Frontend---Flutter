import 'package:power_sense/features/reports/domain/report.dart';

abstract class ReportRepository {
  Future<ReportKPIs> getKPIs();
  Future<List<MonthlyComparison>> getMonthlyComparison();
  Future<List<DepartmentMetric>> getDepartmentsMetrics();
  Future<List<ReportHistory>> getHistory();
  Future<List<RealtimeConsumption>> getRealtimeConsumption();
}