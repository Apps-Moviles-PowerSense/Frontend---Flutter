import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:power_sense/features/devices/data/device_dto.dart';
import 'package:power_sense/core/storage/token_storage.dart';

class DeviceService {
  final TokenStorage tokenStorage;
  final String baseUrl = 'http://34.28.139.66:8080/api/v1/inventory/devices';

  DeviceService({required this.tokenStorage});

  Future<Map<String, String>> getHeaders() async {
    final String? token = await tokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<DeviceDto>> getDevices() async {
    final Uri uri = Uri.parse(baseUrl);
    final Map<String, String> headers = await getHeaders();
    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((jsonItem) => DeviceDto.fromJson(jsonItem)).toList();
    }
    throw Exception('Error al cargar dispositivos: ${response.statusCode}');
  }

  Future<DeviceDto> getDeviceById(String deviceId) async {
    final Uri uri = Uri.parse('$baseUrl/$deviceId');
    final Map<String, String> headers = await getHeaders();
    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return DeviceDto.fromJson(jsonResponse);
    }
    throw Exception('Error al obtener el dispositivo: ${response.statusCode}');
  }

  Future<DeviceDto> createDevice(DeviceDto deviceDto) async {
    final Uri uri = Uri.parse(baseUrl);
    final Map<String, String> headers = await getHeaders();
    
    final http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(deviceDto.toJson()),
    );

    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return DeviceDto.fromJson(jsonResponse);
    }
    throw Exception('Error al crear dispositivo: ${response.statusCode}');
  }

  Future<DeviceDto> updateDevice(String deviceId, DeviceDto deviceDto) async {
    final Uri uri = Uri.parse('$baseUrl/$deviceId');
    final Map<String, String> headers = await getHeaders();
    
    final http.Response response = await http.patch(
      uri,
      headers: headers,
      body: jsonEncode(deviceDto.toJson()),
    );

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return DeviceDto.fromJson(jsonResponse);
    }
    throw Exception('Error al actualizar dispositivo: ${response.statusCode}');
  }

  Future<void> deleteDevice(String deviceId) async {
    final Uri uri = Uri.parse('$baseUrl/$deviceId');
    final Map<String, String> headers = await getHeaders();
    final http.Response response = await http.delete(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al eliminar dispositivo: ${response.statusCode}');
    }
  }

  Future<void> updateDeviceStatus(String deviceId, String status) async {
    final Uri uri = Uri.parse('$baseUrl/$deviceId/status');
    final Map<String, String> headers = await getHeaders();
    
    final http.Response response = await http.patch(
      uri,
      headers: headers,
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al actualizar estado del dispositivo: ${response.statusCode}');
    }
  }

  Future<void> updateAllDevicesStatus(String status) async {
    final Uri uri = Uri.parse('$baseUrl/status/all');
    final Map<String, String> headers = await getHeaders();
    
    final http.Response response = await http.patch(
      uri,
      headers: headers,
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al actualizar todos los estados: ${response.statusCode}');
    }
  }

  Future<void> exportDevices() async {
    final Uri uri = Uri.parse('$baseUrl/export');
    final Map<String, String> headers = await getHeaders();
    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al exportar dispositivos: ${response.statusCode}');
    }
  }

  Future<void> importDevices() async {
    final Uri uri = Uri.parse('$baseUrl/import');
    final Map<String, String> headers = await getHeaders();
    final http.Response response = await http.post(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al importar dispositivos: ${response.statusCode}');
    }
  }
}