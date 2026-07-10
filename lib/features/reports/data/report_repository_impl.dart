import 'package:power_sense/features/reports/domain/report.dart';
import 'package:power_sense/features/reports/domain/report_repository.dart';
import 'package:power_sense/features/reports/data/report_service.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportService reportService;

  ReportRepositoryImpl({required this.reportService});

  @override
  Future<ReportKPIs> getKPIs() async {
    final reportKPIsDto = await reportService.getKPIs();
    return reportKPIsDto.toDomain();
  }

  @override
  Future<List<MonthlyComparison>> getMonthlyComparison() async {
    final monthlyComparisonDtoList = await reportService.getMonthlyComparison();
    return monthlyComparisonDtoList.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<DepartmentMetric>> getDepartmentsMetrics() async {
    final departmentMetricDtoList = await reportService.getDepartmentsMetrics();
    return departmentMetricDtoList.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<ReportHistory>> getHistory() async {
    final reportHistoryDtoList = await reportService.getHistory();
    return reportHistoryDtoList.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<RealtimeConsumption>> getRealtimeConsumption() async {
    final realtimeConsumptionDtoList = await reportService.getRealtimeConsumption();
    return realtimeConsumptionDtoList.map((dto) => dto.toDomain()).toList();
  }
}