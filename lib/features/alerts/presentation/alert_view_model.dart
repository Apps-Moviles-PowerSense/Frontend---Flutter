import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_sense/features/alerts/domain/alert_repository.dart';
import 'package:power_sense/features/alerts/presentation/alert_state.dart';

class AlertViewModel extends Cubit<AlertState> {
  final AlertRepository repository;

  // Seteamos el estado inicial igual que en el login
  AlertViewModel({required this.repository}) : super(AlertInitial()) {
    getAlerts();
  }

  Future<void> getAlerts() async {
    emit(AlertLoading());

    try {
      final alerts = await repository.getAlerts();
      emit(AlertSuccess(alerts: alerts));
    } catch (e) {
      emit(AlertFailure(message: e.toString()));
    }
  }

  Future<void> acknowledgeAlert(String id) async {
    try {
      await repository.acknowledgeAlert(id);
      await getAlerts();
    } catch (e) {
      emit(AlertFailure(message: e.toString()));
    }
  }

  Future<void> acknowledgeAllAlerts() async {
    emit(AlertLoading());

    try {
      await repository.acknowledgeAllAlerts();
      await getAlerts();
    } catch (e) {
      emit(AlertFailure(message: e.toString()));
    }
  }
}