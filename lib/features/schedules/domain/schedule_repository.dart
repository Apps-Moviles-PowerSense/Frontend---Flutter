import 'schedule.dart';

abstract class ScheduleRepository {
  Future<List<Schedule>> getSchedules();
  Future<void> createSchedule({
    required String deviceId, required String deviceName, required String roomName,
    required String startTime, required String endTime, required List<String> days
  });
  Future<Schedule> toggleSchedule(String id, bool enabled);
}
