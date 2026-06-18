import 'package:power_sense/core/storage/token_storage.dart';
import 'package:power_sense/features/auth/data/auth_service.dart';
import 'package:power_sense/features/auth/data/login_response_dto.dart';
import 'package:power_sense/features/auth/domain/auth_repository.dart';
import 'package:power_sense/features/auth/domain/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService service;
  final TokenStorage tokenStorage;
  const AuthRepositoryImpl({required this.service, required this.tokenStorage});

  @override
  Future<User> login(String email, String password) async{
    final LoginResponseDto dto = await service.login(email, password);
    await tokenStorage.saveToken(dto.token);
    return dto.toDomain();
  }

  @override
  Future<void> register(
    String email,
    String password,
    String name,
  ){
    throw UnimplementedError();
  }

}