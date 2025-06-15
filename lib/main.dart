import 'package:flutter/material.dart';
import 'package:intro_screens/core/models/car_model.dart';
import 'package:intro_screens/providers/auth_provider.dart';
import 'package:intro_screens/providers/model_provider.dart';
import 'package:intro_screens/routes/app_routes.dart';
import 'package:provider/provider.dart';

import 'core/models/provider_model.dart';
import 'core/models/service_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()..checkAuthStatus()),
        ChangeNotifierProvider(create: (context) => ModelProvider<ProviderModel>()),
        ChangeNotifierProvider(create: (context) => ModelProvider<ServiceModel>()),
        ChangeNotifierProvider(create: (context) => ModelProvider<CarModel>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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