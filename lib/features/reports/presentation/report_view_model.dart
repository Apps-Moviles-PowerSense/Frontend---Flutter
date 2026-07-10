import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_sense/features/reports/domain/report.dart';
import 'package:power_sense/features/reports/domain/report_repository.dart';
import 'package:power_sense/features/reports/presentation/report_state.dart';

class ReportViewModel extends Cubit<ReportState> {
  final ReportRepository reportRepository;

  ReportViewModel({required this.reportRepository}) : super(ReportInitial());

  Future<void> loadAllReports() async {
    emit(ReportLoading());
    try {
      final results = await Future.wait([
        reportRepository.getKPIs(),
        reportRepository.getMonthlyComparison(),
        reportRepository.getDepartmentsMetrics(),
        reportRepository.getHistory(),
        reportRepository.getRealtimeConsumption(),
      ]);
      
      final kpis = results[0] as ReportKPIs;
      final monthlyComparison = results[1] as List<MonthlyComparison>;
      final departmentsMetrics = results[2] as List<DepartmentMetric>;
      final history = results[3] as List<ReportHistory>;
      final realtimeConsumption = results[4] as List<RealtimeConsumption>;

      emit(ReportSuccess(
        kpis: kpis,
        monthlyComparison: monthlyComparison,
        departmentsMetrics: departmentsMetrics,
        history: history,
        realtimeConsumption: realtimeConsumption,
      ));
    } catch (error) {
      emit(ReportFailure(message: error.toString().replaceAll('Exception: ', '')));
    }
  }
}