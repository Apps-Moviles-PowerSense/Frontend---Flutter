import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    Center(child: Text('Dashboard Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Devices Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Alerts Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Reports Page', style: TextStyle(fontSize: 24))),
  ];
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: [
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