import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intro_screens/core/services/token_manager.dart';

class AuthService {
  final String baseUrl = "http://redexapis.runasp.net/api";
  final FlutterSecureStorage storage = const FlutterSecureStorage();


  Future<Map<String, dynamic>> _sendRequest(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl$endpoint"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "data": responseData};
      } else {
        return {
          "success": false,
          "message": responseData['message'] ?? "Request failed. Please try again."
        };
      }
    } catch (e) {
      return {"success": false, "message": "An unexpected error occurred: $e"};
    }
  }

  // Login function
  Future<bool> login(String email, String password) async {
    final result = await _sendRequest("/Auth/login", {"username": email, "password": password});

    if (result["success"]) {
      String token = result["data"]["token"];
      await TokenStorage().saveToken(token);
      return true;
    } else {
      // print("Login Failed: ${result['message']}");
      return false;
    }
  }

  // signup function
  Future<Map<String, dynamic>> signUp(String username, String email, String password, String phoneNumber) async {
    return await _sendRequest("/Auth/register", {
      "username": username,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
    });
  }

}
