import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:power_sense/features/reports/data/report_dto.dart';
import 'package:power_sense/core/storage/token_storage.dart';

class ReportService {
  final TokenStorage tokenStorage;
  final String baseUrl = 'http://34.28.139.66:8080/api/v1/analytics/reports';

  ReportService({required this.tokenStorage});

  Future<Map<String, String>> getHeaders() async {
    final String? token = await tokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<ReportKPIsDto> getKPIs() async {
    final Uri uri = Uri.parse('$baseUrl/kpis');
    final Map<String, String> headers = await getHeaders();
    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return ReportKPIsDto.fromJson(jsonResponse);
    }
    throw Exception('Error fetching KPIs: ${response.statusCode}');
  }

  Future<List<MonthlyComparisonDto>> getMonthlyComparison() async {
    final Uri uri = Uri.parse('$baseUrl/monthly-comparison');
    final Map<String, String> headers = await getHeaders();
    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((jsonItem) => MonthlyComparisonDto.fromJson(jsonItem)).toList();
    }
    throw Exception('Error fetching monthly comparison: ${response.statusCode}');
  }

  Future<List<DepartmentMetricDto>> getDepartmentsMetrics() async {
    final Uri uri = Uri.parse('$baseUrl/departments');
    final Map<String, String> headers = await getHeaders();
    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((jsonItem) => DepartmentMetricDto.fromJson(jsonItem)).toList();
    }
    throw Exception('Error fetching departments metrics: ${response.statusCode}');
  }

  Future<List<ReportHistoryDto>> getHistory() async {
    final Uri uri = Uri.parse('$baseUrl/history');
    final Map<String, String> headers = await getHeaders();
    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((jsonItem) => ReportHistoryDto.fromJson(jsonItem)).toList();
    }
    throw Exception('Error fetching history: ${response.statusCode}');
  }

  Future<List<RealtimeConsumptionDto>> getRealtimeConsumption() async {
    final Uri uri = Uri.parse('$baseUrl/realtime-consumption');
    final Map<String, String> headers = await getHeaders();
    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((jsonItem) => RealtimeConsumptionDto.fromJson(jsonItem)).toList();
    }
    throw Exception('Error fetching realtime consumption: ${response.statusCode}');
  }
}