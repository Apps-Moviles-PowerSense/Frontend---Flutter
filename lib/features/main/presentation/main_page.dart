import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_sense/core/di/dependency_injection.dart';

import 'package:power_sense/features/dashboard/presentation/dashboard_page.dart';
import 'package:power_sense/features/dashboard/presentation/dashboard_view_model.dart';

import 'package:power_sense/features/devices/presentation/device_page.dart';
import 'package:power_sense/features/devices/presentation/device_view_model.dart';

import 'package:power_sense/features/schedules/presentation/schedule_page.dart';
import 'package:power_sense/features/schedules/presentation/schedule_view_model.dart';

import 'package:power_sense/features/reports/presentation/report_page.dart';
import 'package:power_sense/features/reports/presentation/report_view_model.dart';

import 'package:power_sense/features/alerts/presentation/alert_page.dart';
import 'package:power_sense/features/alerts/presentation/alert_view_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    // Aquí inyectamos cada ViewModel directamente a su respectiva página
    pages = [
      BlocProvider(
        create: (context) => getIt<DashboardViewModel>(),
        child: const DashboardPage(),
      ),
      BlocProvider(
        create: (context) => getIt<DeviceViewModel>(),
        child: const DevicePage(),
      ),
      BlocProvider(
        create: (context) => getIt<ScheduleViewModel>(),
        child: const SchedulePage(),
      ),
      BlocProvider(
        create: (context) => getIt<ReportViewModel>(),
        child: const ReportPage(),
      ),
      BlocProvider(
        create: (context) => getIt<AlertViewModel>(),
        child: const AlertPage(),
      ),
    ];
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: onItemTapped, 
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_mosaic_outlined),
            activeIcon: Icon(Icons.auto_awesome_mosaic),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.electric_bolt_outlined),
            activeIcon: Icon(Icons.electric_bolt),
            label: 'Dispositivos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_outlined),
            activeIcon: Icon(Icons.access_time),
            label: 'Programacion',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Reportes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Alertas',
          ),
        ],
      ),
    );
  }
}