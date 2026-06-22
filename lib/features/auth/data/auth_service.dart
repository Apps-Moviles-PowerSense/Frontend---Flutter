import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:power_sense/features/auth/data/login_request_dto.dart';
import 'package:power_sense/features/auth/data/login_response_dto.dart';
import 'package:power_sense/features/auth/data/register_request_dto.dart';

class AuthService {
  final String baseUrl = 
    'http://34.28.139.66:8080/api/auth';
  
  Future<LoginResponseDto> login(String email, String password) async {
    final Uri uri = Uri.parse('$baseUrl/login');

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
  Future<void> register(
    String email,
    String password,
    String name,
  ) async {
    final Uri uri = Uri.parse('$baseUrl/register');

    try {
      final http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          RegisterRequestDto(
            email: email,
            password: password,
            name: name,
          ).toJson(),
        ),
      );

      // Única validación: Si NO es 200 y NO es 201, lanzamos el error con el body
      if (response.statusCode != HttpStatus.ok && response.statusCode != HttpStatus.created) {
        throw Exception('Código ${response.statusCode}: ${response.body}');
      }
      
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }
}