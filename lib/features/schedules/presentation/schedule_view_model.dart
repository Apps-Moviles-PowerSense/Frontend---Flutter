import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_sense/core/di/dependency_injection.dart';
import 'package:power_sense/features/devices/domain/device_repository.dart';
import 'package:power_sense/features/schedules/domain/schedule_repository.dart';
import 'package:power_sense/features/schedules/domain/schedule.dart';
import 'schedule_state.dart';

class ScheduleViewModel extends Cubit<ScheduleState> {
  final ScheduleRepository repository;
  
  ScheduleViewModel({required this.repository}) : super(ScheduleInitial()) {
    loadSchedules();
  }

  Future<void> loadSchedules() async {
    emit(ScheduleLoading());
    try {
      final list = await repository.getSchedules();
      final deviceRepo = getIt<DeviceRepository>(); 
      
      List<dynamic> devices = [];
      try { 
        final res = await deviceRepo.getDevices(); 
        devices = res is List ? res : [res]; 
      } catch (_) {}
      
      final rooms = list.map((e) => e.roomName).toSet().toList()..sort();
      final stats = _calcStats(list, devices.length);

      emit(ScheduleSuccess(
        schedules: list, filteredSchedules: list, availableDevices: List.from(devices),
        rooms: rooms, stats: stats,
      ));
    } catch (e) {
      emit(ScheduleFailure(message: e.toString()));
    }
  }

  ScheduleStats _calcStats(List<Schedule> s, int total) {
    return ScheduleStats(
      scheduledDevices: "${s.map((e) => e.deviceId).toSet().length}/$total",
      activeSchedules: s.where((e) => e.enabled).length,
      estimatedSavings: s.where((e) => e.enabled).length * 5,
    );
  }

  void onSearchQueryChange(String query) {
    if (state is ScheduleSuccess) {
      final s = state as ScheduleSuccess;
      final filtered = s.schedules.where((e) => e.deviceName.toLowerCase().contains(query.toLowerCase())).toList();
      emit(s.copyWith(searchQuery: query, filteredSchedules: filtered));
    }
  }

  void onTabSelected(String tab) {
    if (state is ScheduleSuccess) emit((state as ScheduleSuccess).copyWith(selectedTab: tab));
  }

  void toggleSchedule(Schedule schedule) async {
    if (state is ScheduleSuccess) {
      try {
        await repository.toggleSchedule(schedule.id, !schedule.enabled);
        loadSchedules();
      } catch (_) {}
    }
  }

  void openCreateDialog() { if (state is ScheduleSuccess) emit((state as ScheduleSuccess).copyWith(isCreateDialogOpen: true)); }
  void closeCreateDialog() { if (state is ScheduleSuccess) emit((state as ScheduleSuccess).copyWith(isCreateDialogOpen: false)); }

  Future<void> createSchedule(String deviceId, String name, String room, String start, String end, List<String> days) async {
    try {
      await repository.createSchedule(deviceId: deviceId, deviceName: name, roomName: room, startTime: start, endTime: end, days: days);
      closeCreateDialog();
      loadSchedules();
    } catch (_) {}
  }
}
