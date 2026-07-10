import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/dashboard_repository.dart';
import 'dashboard_state.dart';

class DashboardViewModel extends Cubit<DashboardState> {
  final DashboardRepository repository;
  DashboardViewModel({required this.repository}) : super(DashboardInitial());

  Future<void> loadKPIs() async {
    emit(DashboardLoading());
    try {
      final kpis = await repository.getKPIs();
      emit(DashboardSuccess(kpis: kpis));
    } catch (e) {
      emit(DashboardFailure(message: e.toString()));
    }
  }
}
