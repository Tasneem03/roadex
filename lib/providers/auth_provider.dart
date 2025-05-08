import 'package:flutter/material.dart';
import 'package:intro_screens/routes/app_routes.dart';

import '../core/services/token_manager.dart';


class AuthProvider with ChangeNotifier {
  final TokenStorage tokenStorage = TokenStorage();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  // Check if user is logged in
  Future<void> checkAuthStatus() async {
    String? token = await tokenStorage.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    await tokenStorage.deleteToken();
    _isAuthenticated = false;
    notifyListeners();
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}
