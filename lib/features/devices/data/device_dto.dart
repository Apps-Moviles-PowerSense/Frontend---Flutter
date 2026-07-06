import 'package:power_sense/features/devices/domain/device.dart';

class DeviceDto {
  final String id;
  final String name;
  final String category;
  final String status;
  final String roomId;
  final String roomName;
  final int watts;

  DeviceDto({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    required this.roomId,
    required this.roomName,
    required this.watts,
  });

  factory DeviceDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> location = json['location'] ?? {};
    final Map<String, dynamic> power = json['power'] ?? {};

    return DeviceDto(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? '',
      roomId: location['roomId'] ?? '',
      roomName: location['roomName'] ?? '',
      watts: power['watts'] != null ? (power['watts'] as num).toInt() : 0,
    );
  }

  Device toDomain() {
    return Device(
      id: id,
      name: name,
      category: category,
      status: status,
      roomId: roomId,
      roomName: roomName,
      watts: watts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'status': status,
      'location': {
        'roomId': roomId,
        'roomName': roomName,
      },
      'power': {
        'watts': watts,
        'voltage': 0,
        'amperage': 0,
      }
    };
  }
}