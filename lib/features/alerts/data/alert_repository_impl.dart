import 'package:power_sense/features/alerts/data/alert_dto.dart';
import 'package:power_sense/features/alerts/data/alert_service.dart';
import 'package:power_sense/features/alerts/domain/alert.dart';
import 'package:power_sense/features/alerts/domain/alert_repository.dart';

class AlertRepositoryImpl implements AlertRepository {
  final AlertService alertService;

  AlertRepositoryImpl({required this.alertService});

  @override
  Future<List<Alert>> getAlerts() async {
    final alertList = await alertService.getAlerts();
    return alertList.map((alertItem) => alertItem.toDomain()).toList();
  }

  @override
  Future<List<Alert>> getRecentAlerts() async {
    final alertList = await alertService.getRecentAlerts();
    return alertList.map((alertItem) => alertItem.toDomain()).toList();
  }

  @override
  Future<Alert> getAlertById(String id) async {
    final alertDto = await alertService.getAlertById(id);
    return alertDto.toDomain();
  }

  @override
  Future<Alert> createAlert(Alert alert) async {
    final alertDtoToSend = AlertDto(
      id: alert.id,
      type: alert.type,
      severity: alert.severity,
      deviceId: alert.deviceId,
      threshold: alert.threshold,
      message: alert.message,
      acknowledged: alert.acknowledged,
      acknowledgedAt: alert.acknowledgedAt,
      createdAt: alert.createdAt,
      updatedAt: alert.updatedAt,
    );

    final responseDto = await alertService.createAlert(alertDtoToSend);
    return responseDto.toDomain();
  }

  @override
  Future<Alert> updateAlert(String id, Alert alert) async {
    final alertDtoToSend = AlertDto(
      id: alert.id,
      type: alert.type,
      severity: alert.severity,
      deviceId: alert.deviceId,
      threshold: alert.threshold,
      message: alert.message,
      acknowledged: alert.acknowledged,
      acknowledgedAt: alert.acknowledgedAt,
      createdAt: alert.createdAt,
      updatedAt: alert.updatedAt,
    );

    final responseDto = await alertService.updateAlert(id, alertDtoToSend);
    return responseDto.toDomain();
  }

  @override
  Future<void> deleteAlert(String id) async {
    await alertService.deleteAlert(id);
  }

  @override
  Future<void> acknowledgeAlert(String id) async {
    await alertService.acknowledgeAlert(id);
  }

  @override
  Future<void> acknowledgeAllAlerts() async {
    final allAlerts = await getAlerts();
    final unacknowledgedAlerts = allAlerts.where((alertItem) => !alertItem.acknowledged).toList();
    
    for (final alertItem in unacknowledgedAlerts) {
      await alertService.acknowledgeAlert(alertItem.id);
    }
  }
}