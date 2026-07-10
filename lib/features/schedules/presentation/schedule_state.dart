import 'package:power_sense/features/schedules/domain/schedule.dart';
import 'package:power_sense/features/devices/domain/device.dart'; 

abstract class ScheduleState {}
class ScheduleInitial extends ScheduleState {}
class ScheduleLoading extends ScheduleState {}
class ScheduleSuccess extends ScheduleState {
  final List<Schedule> schedules;
  final List<Schedule> filteredSchedules;
  final List<Device> availableDevices;
  final String searchQuery;
  final String? selectedRoom;
  final String selectedTab;
  final List<String> rooms;
  final ScheduleStats stats;
  final bool isCreateDialogOpen;

  ScheduleSuccess({
    required this.schedules, required this.filteredSchedules, required this.availableDevices,
    this.searchQuery = "", this.selectedRoom, this.selectedTab = "Dispositivos",
    required this.rooms, required this.stats, this.isCreateDialogOpen = false,
  });

  ScheduleSuccess copyWith({
    List<Schedule>? schedules, List<Schedule>? filteredSchedules, List<Device>? availableDevices,
    String? searchQuery, String? selectedRoom, String? selectedTab, List<String>? rooms,
    ScheduleStats? stats, bool? isCreateDialogOpen, bool clearRoom = false,
  }) {
    return ScheduleSuccess(
      schedules: schedules ?? this.schedules,      
      filteredSchedules: filteredSchedules ?? this.filteredSchedules,
      availableDevices: availableDevices ?? this.availableDevices,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedRoom: clearRoom ? null : (selectedRoom ?? this.selectedRoom),
      selectedTab: selectedTab ?? this.selectedTab,
      rooms: rooms ?? this.rooms,
      stats: stats ?? this.stats,
      isCreateDialogOpen: isCreateDialogOpen ?? this.isCreateDialogOpen,
    );
  }
}
class ScheduleFailure extends ScheduleState {
  final String message;
  ScheduleFailure({required this.message});
}
