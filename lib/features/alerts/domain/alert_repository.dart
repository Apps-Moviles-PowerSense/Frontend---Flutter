import 'package:power_sense/features/alerts/domain/alert.dart';

abstract class AlertRepository {
  Future<List<Alert>> getAlerts();
  Future<List<Alert>> getRecentAlerts();
  Future<Alert> getAlertById(String id);
  Future<Alert> createAlert(Alert alert);
  Future<Alert> updateAlert(String id, Alert alert);
  Future<void> deleteAlert(String id);
  Future<void> acknowledgeAlert(String id);
  Future<void> acknowledgeAllAlerts();
}