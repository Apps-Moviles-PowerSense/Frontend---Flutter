import '../domain/schedule.dart';

class ScheduleDto {
  final String id;
  final String deviceId;
  final String deviceName;
  final String roomName;
  final bool enabled;
  final List<dynamic> schedules;

  ScheduleDto({required this.id, required this.deviceId, required this.deviceName, required this.roomName, required this.enabled, required this.schedules});

  factory ScheduleDto.fromJson(Map<String, dynamic> json) {
    return ScheduleDto(
      id: json['id'] ?? '',
      deviceId: json['deviceId'] ?? '',
      deviceName: json['deviceName'] ?? '',
      roomName: json['roomName'] ?? '',
      enabled: json['enabled'] ?? false,
      schedules: json['schedules'] ?? [],
    );
  }

  Schedule toDomain() {
    final onAction = schedules.firstWhere((e) => e['action'] == 'ON', orElse: () => {'time': 'N/A'});
    final offAction = schedules.firstWhere((e) => e['action'] == 'OFF', orElse: () => {'time': 'N/A'});
    final days = List<String>.from(onAction['days'] ?? []);

    return Schedule(
      id: id,
      deviceId: deviceId,
      deviceName: deviceName,
      roomName: roomName,
      startTime: onAction['time'].toString(),
      endTime: offAction['time'].toString(),
      days: days,
      enabled: enabled,
    );
  }
}
