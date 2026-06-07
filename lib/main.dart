import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/main/presentation/main_page.dart';

void main() {
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}
