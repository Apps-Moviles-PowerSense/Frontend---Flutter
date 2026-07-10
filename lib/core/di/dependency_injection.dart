import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:power_sense/core/storage/token_storage.dart';

import 'package:power_sense/features/auth/data/auth_repository_impl.dart';
import 'package:power_sense/features/auth/data/auth_service.dart';
import 'package:power_sense/features/auth/domain/auth_repository.dart';
import 'package:power_sense/features/auth/presentation/login_view_model.dart';
import 'package:power_sense/features/auth/presentation/register_view_model.dart';

import 'package:power_sense/features/reports/data/report_repository_impl.dart';
import 'package:power_sense/features/reports/data/report_service.dart';
import 'package:power_sense/features/reports/domain/report_repository.dart';
import 'package:power_sense/features/reports/presentation/report_view_model.dart';

import 'package:power_sense/features/dashboard/data/dashboard_repository_impl.dart';
import 'package:power_sense/features/dashboard/data/dashboard_service.dart';
import 'package:power_sense/features/dashboard/domain/dashboard_repository.dart';
import 'package:power_sense/features/dashboard/presentation/dashboard_view_model.dart';

import 'package:power_sense/features/schedules/data/schedule_repository_impl.dart';
import 'package:power_sense/features/schedules/data/schedule_service.dart';
import 'package:power_sense/features/schedules/domain/schedule_repository.dart';
import 'package:power_sense/features/schedules/presentation/schedule_view_model.dart';

import 'package:power_sense/features/devices/data/device_repository_impl.dart';
import 'package:power_sense/features/devices/data/device_service.dart';
import 'package:power_sense/features/devices/domain/device_repository.dart';
import 'package:power_sense/features/devices/presentation/device_view_model.dart';

import 'package:power_sense/features/alerts/data/alert_repository_impl.dart';
import 'package:power_sense/features/alerts/data/alert_service.dart';
import 'package:power_sense/features/alerts/domain/alert_repository.dart';
import 'package:power_sense/features/alerts/presentation/alert_view_model.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  // core
  getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  getIt.registerLazySingleton<TokenStorage>(() => TokenStorage(storage: getIt<FlutterSecureStorage>()));
  
  // auth
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(service: getIt<AuthService>(), tokenStorage: getIt<TokenStorage>()),
  );
  getIt.registerFactory<LoginViewModel>(() => LoginViewModel(repository: getIt<AuthRepository>()));
  getIt.registerFactory<RegisterViewModel>(() => RegisterViewModel(repository: getIt<AuthRepository>()));

// --- REGISTRO FEATURE: REPORTS ---
  getIt.registerLazySingleton<ReportService>(
    () => ReportService(tokenStorage: getIt<TokenStorage>()),
  );
  getIt.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(reportService: getIt<ReportService>()), // <-- Cambiado a reportService
  );
  getIt.registerFactory<ReportViewModel>(
    () => ReportViewModel(reportRepository: getIt<ReportRepository>()), // <-- Cambiado a reportRepository
  );// dashboard
  getIt.registerLazySingleton<DashboardService>(() => DashboardService(tokenStorage: getIt<TokenStorage>()));
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(service: getIt<DashboardService>()),
  );
  getIt.registerFactory<DashboardViewModel>(() => DashboardViewModel(repository: getIt<DashboardRepository>()));

  // schedules
  getIt.registerLazySingleton<ScheduleService>(() => ScheduleService(tokenStorage: getIt<TokenStorage>()));
  getIt.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(service: getIt<ScheduleService>()),
  );
  getIt.registerFactory<ScheduleViewModel>(() => ScheduleViewModel(repository: getIt<ScheduleRepository>()));

  // devices
  getIt.registerLazySingleton<DeviceService>(() => DeviceService(tokenStorage: getIt<TokenStorage>()));
  getIt.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(deviceService: getIt<DeviceService>()),
  );
  getIt.registerFactory<DeviceViewModel>(() => DeviceViewModel(deviceRepository: getIt<DeviceRepository>()));

  // alerts
  getIt.registerLazySingleton<AlertService>(() => AlertService(tokenStorage: getIt<TokenStorage>()));
  getIt.registerLazySingleton<AlertRepository>(
    () => AlertRepositoryImpl(alertService: getIt<AlertService>()),
  );
  getIt.registerFactory<AlertViewModel>(() => AlertViewModel(repository: getIt<AlertRepository>()));
}