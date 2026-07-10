import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:power_sense/core/storage/token_storage.dart';
import 'dashboard_dto.dart';

class DashboardService {
  final TokenStorage tokenStorage;
  final String baseUrl = 'http://34.28.139.66:8080/api/v1/analytics/dashboard';

  DashboardService({required this.tokenStorage});

  Future<DashboardKPIsResponse> getKPIs() async {
    final String? token = await tokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/kpis'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return DashboardKPIsResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al obtener datos del Dashboard');
  }
}
