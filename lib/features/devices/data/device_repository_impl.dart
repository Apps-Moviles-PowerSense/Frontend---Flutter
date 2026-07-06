import 'package:power_sense/features/devices/domain/device.dart';
import 'package:power_sense/features/devices/domain/device_repository.dart';
import 'package:power_sense/features/devices/data/device_service.dart';
import 'package:power_sense/features/devices/data/device_dto.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceService deviceService;

  DeviceRepositoryImpl({required this.deviceService});

  @override
  Future<List<Device>> getDevices() async {
    final List<DeviceDto> deviceDataTransferObjects = await deviceService.getDevices();
    return deviceDataTransferObjects.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Device> getDeviceById(String deviceId) async {
    final DeviceDto deviceDataTransferObject = await deviceService.getDeviceById(deviceId);
    return deviceDataTransferObject.toDomain();
  }

  @override
  Future<Device> createDevice(Device device) async {
    final DeviceDto deviceDtoToSend = DeviceDto(
      id: device.id,
      name: device.name,
      category: device.category,
      status: device.status,
      roomId: device.roomId,
      roomName: device.roomName,
      watts: device.watts,
    );

    final DeviceDto responseDto = await deviceService.createDevice(deviceDtoToSend);
    return responseDto.toDomain();
  }

  @override
  Future<Device> updateDevice(String deviceId, Device device) async {
    final DeviceDto deviceDtoToSend = DeviceDto(
      id: device.id,
      name: device.name,
      category: device.category,
      status: device.status,
      roomId: device.roomId,
      roomName: device.roomName,
      watts: device.watts,
    );

    final DeviceDto responseDto = await deviceService.updateDevice(deviceId, deviceDtoToSend);
    return responseDto.toDomain();
  }

  @override
  Future<void> deleteDevice(String deviceId) async {
    await deviceService.deleteDevice(deviceId);
  }

  @override
  Future<void> updateDeviceStatus(String deviceId, String status) async {
    await deviceService.updateDeviceStatus(deviceId, status);
  }

  @override
  Future<void> updateAllDevicesStatus(String status) async {
    await deviceService.updateAllDevicesStatus(status);
  }

  @override
  Future<void> exportDevices() async {
    await deviceService.exportDevices();
  }

  @override
  Future<void> importDevices() async {
    await deviceService.importDevices();
  }
}