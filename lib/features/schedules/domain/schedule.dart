class Schedule {
  final String id;
  final String deviceId;
  final String deviceName;
  final String roomName;
  final String startTime;
  final String endTime;
  final List<String> days;
  final bool enabled;
  final String deviceCategory;

  Schedule({
    required this.id, required this.deviceId, required this.deviceName,
    required this.roomName, required this.startTime, required this.endTime,
    required this.days, required this.enabled, this.deviceCategory = "GENERIC_POWER",
  });
}

class ScheduleStats {
  final String scheduledDevices;
  final int activeSchedules;
  final int estimatedSavings;
  ScheduleStats({required this.scheduledDevices, required this.activeSchedules, required this.estimatedSavings});
}
