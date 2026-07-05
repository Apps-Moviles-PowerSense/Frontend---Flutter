import 'package:power_sense/features/alerts/domain/alert.dart';

abstract class AlertState {}

class AlertInitial extends AlertState {}

class AlertLoading extends AlertState {}

class AlertSuccess extends AlertState {
  final List<Alert> allAlerts;
  final List<Alert> unreadAlerts;
  final List<Alert> readAlerts;
  final String? selectedType;

  AlertSuccess({
    required this.allAlerts,
    required this.unreadAlerts,
    required this.readAlerts,
    this.selectedType,
  });
}

class AlertFailure extends AlertState {
  final String message;
  AlertFailure({required this.message});
}