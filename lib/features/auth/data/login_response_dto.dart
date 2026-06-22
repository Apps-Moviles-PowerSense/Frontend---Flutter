import 'package:power_sense/features/auth/domain/user.dart';

class LoginResponseDto{
  final String token;
  final String name;
  final String email;

  LoginResponseDto({
    required this.token,
    required this.name,
    required this.email,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> userMap = json['user'] ?? {};
    return LoginResponseDto(
      token: json['token'],
      name: userMap['name'] ?? '',
      email: userMap['email'] ?? '',
    );
  }

  User toDomain() {
    return User(name: name, email: email);
  }
}