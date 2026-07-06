import 'package:power_sense/features/devices/domain/device.dart';

abstract class DeviceState {}

class DeviceInitial extends DeviceState {}

class DeviceLoading extends DeviceState {}

class DeviceSuccess extends DeviceState {
  final List<Device> allDevices;
  final List<Device> filteredDevices;
  final String searchQuery;
  final String? selectedRoom;
  final String? selectedCategory;

  DeviceSuccess({
    required this.allDevices,
    required this.filteredDevices,
    this.searchQuery = '',
    this.selectedRoom,
    this.selectedCategory,
  });
}

class DeviceFailure extends DeviceState {
  final String message;

  DeviceFailure({required this.message});
}