import 'package:flutter/material.dart';
import 'package:fetch_data_demo/pages/home.dart';
import 'package:fetch_data_demo/pages/stress.dart';
import 'package:fetch_data_demo/pages/query_data.dart';
import 'package:fetch_data_demo/pages/save_data.dart';

class NavigatePage extends StatefulWidget {
  const NavigatePage({super.key});

  @override
  State<NavigatePage> createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screen = <Widget>[
    HomePage(),
    QueryData(),
    SaveData(),
    StressPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home, color: Colors.green),
          ),
          BottomNavigationBarItem(
            label: "Query",
            icon: Icon(Icons.cloud_circle, color: Colors.green),
          ),
          BottomNavigationBarItem(
            label: "Save",
            icon: Icon(Icons.save, color: Colors.green),
          ),
          BottomNavigationBarItem(
            label: "Stress",
            icon: Icon(Icons.rate_review, color: Colors.green),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        onTap: _onItemTapped,
      ),
      body: _screen.elementAt(_selectedIndex),
    );
  }
}