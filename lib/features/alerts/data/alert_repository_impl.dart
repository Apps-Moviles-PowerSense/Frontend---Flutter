import 'package:power_sense/features/alerts/data/alert_dto.dart';
import 'package:power_sense/features/alerts/data/alert_service.dart';
import 'package:power_sense/features/alerts/domain/alert.dart';
import 'package:power_sense/features/alerts/domain/alert_repository.dart';

class AlertRepositoryImpl implements AlertRepository {
  final AlertService alertService;

  AlertRepositoryImpl({required this.alertService});

  @override
  Future<List<Alert>> getAlerts() async {
    final dtos = await alertService.getAlerts();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Alert> getAlertById(String id) async {
    final dto = await alertService.getAlertById(id);
    return dto.toDomain();
  }

  @override
  Future<Alert> createAlert(Alert alert) async {
    final dtoToSend = AlertDto(
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

    final responseDto = await alertService.createAlert(dtoToSend);
    return responseDto.toDomain();
  }

  @override
  Future<Alert> updateAlert(String id, Alert alert) async {
    final dtoToSend = AlertDto(
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

    final responseDto = await alertService.updateAlert(id, dtoToSend);
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
    final unacknowledged = allAlerts.where((a) => !a.acknowledged).toList();
    
    for (final alert in unacknowledged) {
      await alertService.acknowledgeAlert(alert.id);
    }
  }
}