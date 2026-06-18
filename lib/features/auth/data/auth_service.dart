import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:power_sense/features/auth/data/login_request_dto.dart';
import 'package:power_sense/features/auth/data/login_response_dto.dart';

class AuthService {
  final String baseUrl = 
    'http://35.202.179.50:8080/api/auth/login';
  
  Future<LoginResponseDto> login(String email, String password) async {
    final Uri uri = Uri.parse(baseUrl);

    final http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        LoginRequestDto(email: email, password: password).toJson(),
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body);
      return LoginResponseDto.fromJson(json);
    }
    throw Exception('Failed to login');
  
  }
}