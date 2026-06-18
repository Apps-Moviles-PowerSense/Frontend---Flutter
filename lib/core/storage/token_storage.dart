import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final String tokenKey = 'auth_token';
  final FlutterSecureStorage storage;

  const TokenStorage({required this.storage});

  Future<void> saveToken(String token) async {
    await storage.write(key: tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: tokenKey);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: tokenKey);
  }
}