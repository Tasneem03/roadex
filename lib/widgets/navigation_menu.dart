import 'package:flutter/material.dart';
import 'package:intro_screens/screens/home/service_requests_screen.dart';

import '../screens/home/cars_screen.dart';
import '../screens/home/chat_screen.dart';
import '../screens/home/profile_screen.dart';
import '../screens/home/services_screen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      // HomeScreen(),
      ServicesScreen(),
      CarsScreen(),
      // const MapScreen(),
      const ServiceRequestsScreen(),
      const ChatScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: const Color(0xff3A3434),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xff3A3434),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          /*BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: "Services",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: "Cars",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services_rounded),
            label: "My Requests",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
