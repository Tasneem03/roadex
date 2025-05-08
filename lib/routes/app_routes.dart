import 'package:flutter/material.dart';
import 'package:intro_screens/map_pages/map_screen.dart';
import 'package:intro_screens/screens/home/providers_screen.dart';

import 'package:intro_screens/widgets/navigation_menu.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/home/cars_screen.dart';
import '../screens/home/chat_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/profile_screen.dart';
import '../screens/home/services_screen.dart';
import '../screens/onboarding/intro_screen.dart';


class AppRoutes {

  static const String splash = '/';
  static const String intro = '/intro';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String chat = '/chat';
  static const String services = '/services';
  static const String myCars = '/cars';
  static const String navigationMenu = '/navigationMenu';
  static const String providers = '/providers';
  static const String map = '/map';

  static Map<String, Widget Function(BuildContext)> routes = {
    splash: (context) => SplashScreen(),
    intro: (context) => IntroScreen(),
    login: (context) => LoginScreen(),
    signup: (context) => SignupScreen(),
    home: (context) => HomeScreen(),
    profile: (context) => ProfileScreen(),
    chat: (context) => ChatScreen(),
    services: (context) => ServicesScreen(),
    myCars: (context) => CarsScreen(),
    navigationMenu: (context) => NavigationMenu(),
    map: (context) => MapScreen(),
  };
}
