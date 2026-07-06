import 'package:power_sense/features/devices/domain/device.dart';

abstract class DeviceRepository {
  Future<List<Device>> getDevices();
  Future<Device> getDeviceById(String deviceId);
  Future<Device> createDevice(Device device);
  Future<Device> updateDevice(String deviceId, Device device);
  Future<void> deleteDevice(String deviceId);
  Future<void> updateDeviceStatus(String deviceId, String status);
  Future<void> updateAllDevicesStatus(String status);
  Future<void> exportDevices();
  Future<void> importDevices();
}