import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:power_sense/core/storage/token_storage.dart';
import 'package:power_sense/features/auth/data/auth_repository_impl.dart';
import 'package:power_sense/features/auth/data/auth_service.dart';
import 'package:power_sense/features/auth/domain/auth_repository.dart';
import 'package:power_sense/features/auth/presentation/login_view_model.dart';
import 'package:power_sense/features/auth/presentation/register_view_model.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {

  // Auth Service
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  
  // Secure Storage para el token
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  //Token Storage
  getIt.registerLazySingleton<TokenStorage>(
    () => TokenStorage(storage: getIt<FlutterSecureStorage>()),
  );
  // Auth Repository
  getIt.registerLazySingleton<AuthRepository>(
    
    () => AuthRepositoryImpl(
      service: getIt<AuthService>(),
      tokenStorage: getIt<TokenStorage>(),
    ),
  );

  // Login ViewModel 
  getIt.registerFactory<LoginViewModel>(
    () => LoginViewModel(repository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<RegisterViewModel>(
    () => RegisterViewModel(repository: getIt<AuthRepository>()),
  );
}