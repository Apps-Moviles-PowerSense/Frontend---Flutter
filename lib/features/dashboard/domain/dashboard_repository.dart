import 'dashboard_kpis.dart';
abstract class DashboardRepository {
  Future<DashboardKPIs> getKPIs();
}
