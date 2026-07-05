import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_sense/features/alerts/domain/alert_repository.dart';
import 'package:power_sense/features/alerts/presentation/alert_state.dart';

class AlertViewModel extends Cubit<AlertState> {
  final AlertRepository repository;

  AlertViewModel({required this.repository}) : super(AlertInitial()) {
    getAlerts();
  }

  Future<void> getAlerts({String? currentFilter}) async {
    emit(AlertLoading());
    try {
      final alerts = await repository.getAlerts();
      
      var filtered = alerts;
      if (currentFilter != null) {
        filtered = alerts.where((alert) => alert.type == currentFilter).toList();
      }

      final unread = filtered.where((alert) => !alert.acknowledged).toList();
      final read = filtered.where((alert) => alert.acknowledged).toList();

      emit(AlertSuccess(
        allAlerts: alerts,
        unreadAlerts: unread,
        readAlerts: read,
        selectedType: currentFilter,
      ));
    } catch (error) {
      emit(AlertFailure(message: error.toString()));
    }
  }

  Future<void> onTypeFilterSelected(String? type) async {
    if (state is AlertSuccess) {
      final currentState = state as AlertSuccess;
      
      var filtered = currentState.allAlerts;
      if (type != null) {
        filtered = currentState.allAlerts.where((alert) => alert.type == type).toList();
      }

      final unread = filtered.where((alert) => !alert.acknowledged).toList();
      final read = filtered.where((alert) => alert.acknowledged).toList();

      emit(AlertSuccess(
        allAlerts: currentState.allAlerts,
        unreadAlerts: unread,
        readAlerts: read,
        selectedType: type,
      ));
    }
  }

  Future<void> acknowledgeAlert(String id) async {
    if (state is AlertSuccess) {
      final currentFilter = (state as AlertSuccess).selectedType;
      emit(AlertLoading()); 

      try {
        await repository.acknowledgeAlert(id);
        await getAlerts(currentFilter: currentFilter);
      } catch (error) {
        emit(AlertFailure(message: error.toString()));
        await getAlerts(currentFilter: currentFilter);
      }
    }
  }

  Future<void> acknowledgeAll() async {
    if (state is AlertSuccess) {
      final currentState = state as AlertSuccess;
      final currentFilter = currentState.selectedType;
      
      if (currentState.unreadAlerts.isEmpty) return;

      emit(AlertLoading()); 

      try {
        await Future.wait(
          currentState.unreadAlerts.map((alert) => repository.acknowledgeAlert(alert.id))
        );
        await getAlerts(currentFilter: currentFilter);
      } catch (error) {
        emit(AlertFailure(message: error.toString()));
        await getAlerts(currentFilter: currentFilter); 
      }
    }
  }
}