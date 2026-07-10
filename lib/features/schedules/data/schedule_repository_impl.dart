import '../domain/schedule.dart';
import '../domain/schedule_repository.dart';
import 'schedule_service.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleService service;
  ScheduleRepositoryImpl({required this.service});

  @override
  Future<List<Schedule>> getSchedules() async {
    final dtos = await service.fetchSchedules();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<void> createSchedule({
    required String deviceId, required String deviceName, required String roomName,
    required String startTime, required String endTime, required List<String> days
  }) async {
    final startParts = startTime.split(':');
    final endParts = endTime.split(':');
    final request = {
      "deviceId": deviceId,
      "deviceName": deviceName,
      "roomName": roomName,
      "enabled": true,
      "schedules": [
        {"action": "ON", "time": {"hour": int.parse(startParts[0]), "minute": int.parse(startParts[1])}, "days": days},
        {"action": "OFF", "time": {"hour": int.parse(endParts[0]), "minute": int.parse(endParts[1])}, "days": days}
      ]
    };
    await service.createSchedule(request);
  }

  @override
  Future<Schedule> toggleSchedule(String id, bool enabled) async {
    final dto = await service.toggleSchedule(id, enabled);
    return dto.toDomain();
  }
}
