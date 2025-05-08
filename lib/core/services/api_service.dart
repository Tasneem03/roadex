import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intro_screens/core/models/provider_model.dart';
import 'package:intro_screens/core/models/user_model.dart';
import 'package:intro_screens/core/services/token_manager.dart';
import 'package:intro_screens/providers/auth_provider.dart';

import '../models/car_model.dart';
import '../models/service_model.dart';

class ApiService {
  final String baseUrl = "http://redexapis.runasp.net/api";
  final TokenStorage tokenStorage = TokenStorage();

  // get services function
  Future<List<ServiceModel>> getServices() async {
    var url = Uri.parse('$baseUrl/Services');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData.map((json) => ServiceModel.fromJson(json)).toList();
      } else {
        // print('Request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // print('Error fetching services: $e');
      return [];
    }
  }

  // get user info functions
  Future<UserModel?> getUserProfile(BuildContext context) async {
    try {
      String? token = await TokenStorage().getToken();

      // print("Retrieved Token: $token"); //

      if (token == null) {
        print("No token found!");
        return null;
      }

      final response = await http.get(
        Uri.parse("$baseUrl/Customers/me"),
        headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // print("API Response Status Code: ${response.statusCode}");
      // print("API Response Body: ${response.body}"); //

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else if (response.statusCode == 401) {
        print("Unauthorized - Logging out");
        await AuthProvider().logout(context);
        return null;
      } else {
        // print("Error: ${response.statusCode} - ${response.body}");
        throw Exception("Failed to load user profile");
      }
    } catch (e) {
      // print("Error fetching user profile: $e");
      return null;
    }
  }

  // add car function
  Future<bool> addCar({required String licensePlate, required String make, required String model, required String year}) async {
    var url = Uri.parse('$baseUrl/Vehicles');

    try {
      String? token = await tokenStorage.getToken(); // Retrieve the token

      if (token == null) {
        throw Exception("No authentication token found.");
      }

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "licensePlate": licensePlate,
          "make": make,
          "model": model,
          "year": year,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully added
        return true;
      } else {
        // Print error for debugging
        print("Error adding car: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception in addCar: $e");
      return false;
    }
  }

  // get user cars
  Future<List<CarModel>> getCars() async {
    String? token = await tokenStorage.getToken();
    if (token == null) return [];

    var url = Uri.parse("$baseUrl/Vehicles");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map<CarModel>((json) => CarModel.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching cars: $e");
      return [];
    }
  }

  // delete car
  Future<bool> deleteCar(int carId) async {
    String? token = await tokenStorage.getToken();
    if (token == null) return false;

    var url = Uri.parse("$baseUrl/Vehicles/$carId");

    try {
      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Error deleting car: $e");
      return false;
    }
  }


  // update location
  Future<bool> updateLocation(double latitude, double longitude) async {
    String? token = await tokenStorage.getToken();
    if (token == null) {
      // print("Token is null, authentication required.");
      return false;
    }

    final response = await http.put(
      Uri.parse("$baseUrl/Customers/me/location"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode({
        "latitude": latitude,
        "longitude": longitude,
      }),
    );

    // print("API Response Code: ${response.statusCode}");
    // print("API Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  // make a service request
  Future<bool> requestService(int serviceId, int vehicleId, String providerId, double latitude, double longitude, String notes) async{
    var url = Uri.parse('$baseUrl/ServiceRequests');

    try {
      String? token = await tokenStorage.getToken();

      if (token == null) {
        throw Exception("No authentication token found.");
      }

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "notes": notes,
          "latitude": latitude,
          "longitude": longitude,
          "providerId": providerId,
          "serviceId": serviceId,
          "vehicleId": vehicleId
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error making request: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception in addCar: $e");
      return false;
    }
  }


  // get available providers for a specific service
  Future<List<Provider>> getProviders(int serviceId) async {
    var url = Uri.parse('$baseUrl/Providers/available-providers/$serviceId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData.map((json) => Provider.fromJson(json)).toList();
      } else {
        print('Request failed with status: ${response.statusCode} body == ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching services: $e');
      return [];
    }
  }

}
