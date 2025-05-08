import 'package:flutter/material.dart';
import 'package:intro_screens/providers/auth_provider.dart';
import 'package:intro_screens/routes/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider()..checkAuthStatus(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return MaterialApp(
          color: Colors.white,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xff3A3434),
          ),
          title: 'RoadEx',
          initialRoute: AppRoutes.splash,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
