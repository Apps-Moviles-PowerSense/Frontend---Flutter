import 'package:power_sense/features/alerts/domain/alert.dart';

abstract class AlertState {}

class AlertInitial extends AlertState {}

class AlertLoading extends AlertState {}

class AlertSuccess extends AlertState {
  final List<Alert> alerts;
  AlertSuccess({required this.alerts});
}

class AlertFailure extends AlertState {
  final String message;
  AlertFailure({required this.message});
}