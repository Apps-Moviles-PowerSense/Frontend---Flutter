import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:power_sense/features/alerts/data/alert_dto.dart';
import 'package:power_sense/core/storage/token_storage.dart';

class AlertService {
  final TokenStorage tokenStorage;
  final String baseUrl = 'http://34.28.139.66:8080/api/v1/analytics/alerts';

  AlertService({required this.tokenStorage});

  Future<Map<String, String>> getHeaders() async {
    final String? token = await tokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<AlertDto>> getAlerts() async {
    final Uri uri = Uri.parse(baseUrl);
    final headers = await getHeaders();
    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => AlertDto.fromJson(json)).toList();
    }
    throw Exception('Error al cargar alertas: ${response.statusCode}');
  }

  Future<List<AlertDto>> getRecentAlerts() async {
    final Uri uri = Uri.parse('$baseUrl/recent');
    final headers = await getHeaders();
    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => AlertDto.fromJson(json)).toList();
    }
    throw Exception('Error al cargar alertas recientes: ${response.statusCode}');
  }

  Future<AlertDto> getAlertById(String id) async {
    final Uri uri = Uri.parse('$baseUrl/$id');
    final headers = await getHeaders();
    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      return AlertDto.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al obtener alerta: ${response.statusCode}');
  }

  Future<AlertDto> createAlert(AlertDto alertDto) async {
    final Uri uri = Uri.parse(baseUrl);
    final headers = await getHeaders();
    final http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(alertDto.toJson()),
    );

    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
      return AlertDto.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al crear alerta: ${response.statusCode}');
  }

  Future<AlertDto> updateAlert(String id, AlertDto alertDto) async {
    final Uri uri = Uri.parse('$baseUrl/$id');
    final headers = await getHeaders();
    final http.Response response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(alertDto.toJson()),
    );

    if (response.statusCode == HttpStatus.ok) {
      return AlertDto.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al actualizar alerta: ${response.statusCode}');
  }

  Future<void> deleteAlert(String id) async {
    final Uri uri = Uri.parse('$baseUrl/$id');
    final headers = await getHeaders();
    final http.Response response = await http.delete(uri, headers: headers);

    if (response.statusCode != HttpStatus.ok && response.statusCode != HttpStatus.noContent) {
      throw Exception('Error al eliminar alerta: ${response.statusCode}');
    }
  }

  Future<void> acknowledgeAlert(String id) async {
    final Uri uri = Uri.parse('$baseUrl/$id/acknowledge');
    final headers = await getHeaders();
    final http.Response response = await http.patch(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al reconocer alerta: ${response.statusCode}');
    }
  }
}