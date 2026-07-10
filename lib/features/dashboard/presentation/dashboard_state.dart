import '../domain/dashboard_kpis.dart';
abstract class DashboardState {}
class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}
class DashboardSuccess extends DashboardState {
  final DashboardKPIs kpis;
  DashboardSuccess({required this.kpis});
}
class DashboardFailure extends DashboardState {
  final String message;
  DashboardFailure({required this.message});
}
