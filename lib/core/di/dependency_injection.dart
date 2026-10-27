import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:power_sense/core/storage/token_storage.dart';
import 'package:power_sense/features/auth/data/auth_repository_impl.dart';
import 'package:power_sense/features/auth/data/auth_service.dart';
import 'package:power_sense/features/auth/domain/auth_repository.dart';
import 'package:power_sense/features/auth/presentation/login_view_model.dart';
import 'package:power_sense/features/auth/presentation/register_view_model.dart';

// Imports de Reportes
import 'package:power_sense/features/reports/data/report_repository_impl.dart';
import 'package:power_sense/features/reports/data/report_service.dart';
import 'package:power_sense/features/reports/domain/report_repository.dart';
import 'package:power_sense/features/reports/presentation/report_view_model.dart';

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

  // --- REPORTES ---
  
  // Report Service
  getIt.registerLazySingleton<ReportService>(
    () => ReportService(tokenStorage: getIt<TokenStorage>()),
  );

  // Report Repository
  getIt.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(reportService: getIt<ReportService>()),
  );

  // Report ViewModel
  getIt.registerFactory<ReportViewModel>(
    () => ReportViewModel(reportRepository: getIt<ReportRepository>()),
  );
}