import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_sense/core/di/dependency_injection.dart';
import 'package:power_sense/features/auth/presentation/login_page.dart';
import 'package:power_sense/features/auth/presentation/login_view_model.dart';
import 'package:power_sense/features/auth/presentation/register_view_model.dart';
import 'package:provider/provider.dart';


void main() {
  setupDependencies();
  runApp(
    MultiProvider(
    providers: [
      BlocProvider(create: (context)=> getIt<LoginViewModel>()),
      BlocProvider(create: (context) => getIt<RegisterViewModel>()),
    ],
    child: MainApp(),
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
