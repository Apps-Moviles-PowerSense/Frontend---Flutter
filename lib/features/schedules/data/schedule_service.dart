import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:power_sense/core/storage/token_storage.dart';
import 'schedule_dto.dart';

class ScheduleService {
  final TokenStorage tokenStorage;
  final String baseUrl = 'http://34.28.139.66:8080/api/v1/inventory/schedules';

  ScheduleService({required this.tokenStorage});

  Future<List<ScheduleDto>> fetchSchedules() async {
    final token = await tokenStorage.getToken();
    final response = await http.get(Uri.parse(baseUrl), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => ScheduleDto.fromJson(e)).toList();
    }
    throw Exception('error al obtener schedules del servidor');
  }

  Future<void> createSchedule(Map<String, dynamic> request) async {
    final token = await tokenStorage.getToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(request),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('error al crear schedule');
    }
  }

  Future<ScheduleDto> toggleSchedule(String id, bool enabled) async {
    final token = await tokenStorage.getToken();
    final response = await http.patch(
      Uri.parse('$baseUrl/$id/toggle'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'enabled': enabled}),
    );
    if (response.statusCode == 200) {
      return ScheduleDto.fromJson(jsonDecode(response.body));
    }
    throw Exception('error al alternar schedule');
  }
}
