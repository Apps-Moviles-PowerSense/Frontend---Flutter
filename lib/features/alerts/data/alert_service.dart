import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:power_sense/features/alerts/data/alert_dto.dart';

class AlertService{

  final String baseUrl = 
    'http://34.28.139.66:8080/api/v1/analytics/alerts';
  // Get Alerts
  Future<List<AlertDto>> getAlerts() async {
    final Uri uri = Uri.parse(baseUrl);

    final http.Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => AlertDto.fromJson(json)).toList();
    }
    
    throw Exception('Error loading alerts: ${response.statusCode}');
  }

  Future<AlertDto> getAlertById(String id) async {
    final Uri uri = Uri.parse('$baseUrl/$id');

    final http.Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body);
      return AlertDto.fromJson(json);
    }
    
    throw Exception('Error obtaining alert: ${response.statusCode}');
  }

  Future<AlertDto> createAlert(AlertDto alertDto) async {
    final Uri uri = Uri.parse(baseUrl);

    final http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(alertDto.toJson()),
    );

    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
      final json = jsonDecode(response.body);
      return AlertDto.fromJson(json);
    }
    
    throw Exception('Error creating alert: ${response.statusCode}');
  }

  Future<AlertDto> updateAlert(String id, AlertDto alertDto) async {
    final Uri uri = Uri.parse('$baseUrl/$id');

    final http.Response response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(alertDto.toJson()),
    );

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body);
      return AlertDto.fromJson(json);
    }
    
    throw Exception('Error al actualizar la alerta: ${response.statusCode}');
  }

  Future<void> deleteAlert(String id) async {
    final Uri uri = Uri.parse('$baseUrl/$id');

    final http.Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    
    throw Exception('Error al eliminar la alerta: ${response.statusCode}');
  }

  Future<void> acknowledgeAlert(String id) async {
    final Uri uri = Uri.parse('$baseUrl/$id/acknowledge');

    final http.Response response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    
    throw Exception('Error al reconocer la alerta: ${response.statusCode}');
  }
}