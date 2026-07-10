import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:power_sense/core/di/dependency_injection.dart';

import 'package:power_sense/features/auth/presentation/login_page.dart';
import 'package:power_sense/features/auth/presentation/login_view_model.dart';
import 'package:power_sense/features/auth/presentation/register_view_model.dart';
import 'package:power_sense/features/reports/presentation/report_view_model.dart';
import 'package:power_sense/features/dashboard/presentation/dashboard_view_model.dart';
import 'package:power_sense/features/schedules/presentation/schedule_view_model.dart';
import 'package:power_sense/features/devices/presentation/device_view_model.dart';
import 'package:power_sense/features/alerts/presentation/alert_view_model.dart';

void main() {
  setupDependencies();
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (context) => getIt<LoginViewModel>()),
        BlocProvider(create: (context) => getIt<RegisterViewModel>()),
        BlocProvider(create: (context) => getIt<ReportViewModel>()),
        BlocProvider(create: (context) => getIt<DashboardViewModel>()),
        BlocProvider(create: (context) => getIt<ScheduleViewModel>()),
        BlocProvider(create: (context) => getIt<DeviceViewModel>()),
        BlocProvider(create: (context) => getIt<AlertViewModel>()),
      ],
      child: const MainApp(),
    ) 
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}