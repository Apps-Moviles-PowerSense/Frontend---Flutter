import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_sense/features/devices/domain/device.dart';
import 'package:power_sense/features/devices/domain/device_repository.dart';
import 'package:power_sense/features/devices/presentation/device_state.dart';

class DeviceViewModel extends Cubit<DeviceState> {
  final DeviceRepository deviceRepository;

  DeviceViewModel({required this.deviceRepository}) : super(DeviceInitial()) {
    getDevices();
  }

  Future<void> getDevices() async {
    emit(DeviceLoading());
    try {
      final List<Device> allDevices = await deviceRepository.getDevices();
      emit(DeviceSuccess(
        allDevices: allDevices,
        filteredDevices: allDevices,
      ));
    } catch (error) {
      emit(DeviceFailure(message: error.toString()));
    }
  }

  void onFiltersChanged({String? query, String? room, String? category, bool clearRoom = false, bool clearCategory = false}) {
    if (state is DeviceSuccess) {
      final currentState = state as DeviceSuccess;
      
      final newQuery = query ?? currentState.searchQuery;
      final newRoom = clearRoom ? null : (room ?? currentState.selectedRoom);
      final newCategory = clearCategory ? null : (category ?? currentState.selectedCategory);

      final filtered = currentState.allDevices.where((device) {
        final matchesSearch = newQuery.isEmpty || device.name.toLowerCase().contains(newQuery.toLowerCase());
        final matchesRoom = newRoom == null || device.roomName == newRoom;
        final matchesCategory = newCategory == null || device.category == newCategory;
        return matchesSearch && matchesRoom && matchesCategory;
      }).toList();

      emit(DeviceSuccess(
        allDevices: currentState.allDevices,
        filteredDevices: filtered,
        searchQuery: newQuery,
        selectedRoom: newRoom,
        selectedCategory: newCategory,
      ));
    }
  }

  Future<void> toggleDeviceStatus(Device device) async {
    if (state is DeviceSuccess) {
      final currentState = state as DeviceSuccess;
      final String newStatus = device.status.toLowerCase() == 'active' ? 'inactive' : 'active';

      final updatedAllDevices = currentState.allDevices.map((d) {
        if (d.id == device.id) {
          return Device(
            id: d.id,
            name: d.name,
            category: d.category,
            status: newStatus,
            roomId: d.roomId,
            roomName: d.roomName,
            watts: d.watts,
          );
        }
        return d;
      }).toList();

      final updatedFilteredDevices = currentState.filteredDevices.map((d) {
        if (d.id == device.id) {
          return Device(
            id: d.id,
            name: d.name,
            category: d.category,
            status: newStatus,
            roomId: d.roomId,
            roomName: d.roomName,
            watts: d.watts,
          );
        }
        return d;
      }).toList();

      emit(DeviceSuccess(
        allDevices: updatedAllDevices,
        filteredDevices: updatedFilteredDevices,
        searchQuery: currentState.searchQuery,
        selectedRoom: currentState.selectedRoom,
        selectedCategory: currentState.selectedCategory,
      ));

      try {
        await deviceRepository.updateDeviceStatus(device.id, newStatus);
        final List<Device> freshDevices = await deviceRepository.getDevices();
        _applyFreshDevicesWithFilters(freshDevices, currentState.searchQuery, currentState.selectedRoom, currentState.selectedCategory);
      } catch (error) {
        emit(DeviceFailure(message: error.toString()));
        emit(currentState);
      }
    }
  }

  Future<void> setAllDevicesStatus(bool turnOn) async {
    if (state is DeviceSuccess) {
      final currentState = state as DeviceSuccess;
      final String targetStatus = turnOn ? 'active' : 'inactive';

      final updatedAllDevices = currentState.allDevices.map((d) {
        return Device(
          id: d.id,
          name: d.name,
          category: d.category,
          status: targetStatus,
          roomId: d.roomId,
          roomName: d.roomName,
          watts: d.watts,
        );
      }).toList();

      final updatedFilteredDevices = currentState.filteredDevices.map((d) {
        return Device(
          id: d.id,
          name: d.name,
          category: d.category,
          status: targetStatus,
          roomId: d.roomId,
          roomName: d.roomName,
          watts: d.watts,
        );
      }).toList();

      emit(DeviceSuccess(
        allDevices: updatedAllDevices,
        filteredDevices: updatedFilteredDevices,
        searchQuery: currentState.searchQuery,
        selectedRoom: currentState.selectedRoom,
        selectedCategory: currentState.selectedCategory,
      ));

      try {
        await deviceRepository.updateAllDevicesStatus(targetStatus);
        final List<Device> freshDevices = await deviceRepository.getDevices();
        _applyFreshDevicesWithFilters(freshDevices, currentState.searchQuery, currentState.selectedRoom, currentState.selectedCategory);
      } catch (error) {
        emit(DeviceFailure(message: error.toString()));
        emit(currentState);
      }
    }
  }

  Future<void> setRoomDevicesStatus(String roomId, bool turnOn, List<Device> currentDevices) async {
    if (state is DeviceSuccess) {
      final currentState = state as DeviceSuccess;
      final String targetStatus = turnOn ? 'active' : 'inactive';

      final updatedAllDevices = currentState.allDevices.map((d) {
        if (d.roomId == roomId) {
          return Device(
            id: d.id,
            name: d.name,
            category: d.category,
            status: targetStatus,
            roomId: d.roomId,
            roomName: d.roomName,
            watts: d.watts,
          );
        }
        return d;
      }).toList();

      final updatedFilteredDevices = currentState.filteredDevices.map((d) {
        if (d.roomId == roomId) {
          return Device(
            id: d.id,
            name: d.name,
            category: d.category,
            status: targetStatus,
            roomId: d.roomId,
            roomName: d.roomName,
            watts: d.watts,
          );
        }
        return d;
      }).toList();

      emit(DeviceSuccess(
        allDevices: updatedAllDevices,
        filteredDevices: updatedFilteredDevices,
        searchQuery: currentState.searchQuery,
        selectedRoom: currentState.selectedRoom,
        selectedCategory: currentState.selectedCategory,
      ));

      try {
        final roomDevices = currentDevices.where((d) => d.roomId == roomId).toList();
        await Future.wait(
          roomDevices.map((d) => deviceRepository.updateDeviceStatus(d.id, targetStatus))
        );
        final List<Device> freshDevices = await deviceRepository.getDevices();
        _applyFreshDevicesWithFilters(freshDevices, currentState.searchQuery, currentState.selectedRoom, currentState.selectedCategory);
      } catch (error) {
        emit(DeviceFailure(message: error.toString()));
        emit(currentState);
      }
    }
  }

  Future<void> createDevice(Device device) async {
    if (state is DeviceSuccess) {
      final currentState = state as DeviceSuccess;
      emit(DeviceLoading());
      try {
        await deviceRepository.createDevice(device);
        final List<Device> freshDevices = await deviceRepository.getDevices();
        _applyFreshDevicesWithFilters(freshDevices, currentState.searchQuery, currentState.selectedRoom, currentState.selectedCategory);
      } catch (error) {
        emit(DeviceFailure(message: error.toString()));
        emit(currentState);
      }
    }
  }

  Future<void> updateDevice(String id, Device updatedDevice) async {
    if (state is DeviceSuccess) {
      final currentState = state as DeviceSuccess;
      emit(DeviceLoading());
      try {
        await deviceRepository.updateDevice(id, updatedDevice);
        final List<Device> freshDevices = await deviceRepository.getDevices();
        _applyFreshDevicesWithFilters(freshDevices, currentState.searchQuery, currentState.selectedRoom, currentState.selectedCategory);
      } catch (error) {
        emit(DeviceFailure(message: error.toString()));
        emit(currentState);
      }
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    if (state is DeviceSuccess) {
      final currentState = state as DeviceSuccess;
      emit(DeviceLoading());
      try {
        await deviceRepository.deleteDevice(deviceId);
        final List<Device> freshDevices = await deviceRepository.getDevices();
        _applyFreshDevicesWithFilters(freshDevices, currentState.searchQuery, currentState.selectedRoom, currentState.selectedCategory);
      } catch (error) {
        emit(DeviceFailure(message: error.toString()));
        emit(currentState);
      }
    }
  }

  void _applyFreshDevicesWithFilters(List<Device> freshDevices, String query, String? room, String? category) {
    final filtered = freshDevices.where((device) {
      final matchesSearch = query.isEmpty || device.name.toLowerCase().contains(query.toLowerCase());
      final matchesRoom = room == null || device.roomName == room;
      final matchesCategory = category == null || device.category == category;
      return matchesSearch && matchesRoom && matchesCategory;
    }).toList();

    emit(DeviceSuccess(
      allDevices: freshDevices,
      filteredDevices: filtered,
      searchQuery: query,
      selectedRoom: room,
      selectedCategory: category,
    ));
  }
}