import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookingStorage {
  static final BookingStorage _instance = BookingStorage._internal();

  factory BookingStorage() => _instance;

  BookingStorage._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Service ID methods
  Future<void> saveServiceId(int serviceId) async {
    await _secureStorage.write(key: "service_id", value: serviceId.toString());
  }

  Future<int?> getServiceId() async {
    String? value = await _secureStorage.read(key: "service_id");
    return value != null ? int.tryParse(value) : null;
  }

  Future<void> deleteServiceId() async {
    await _secureStorage.delete(key: "service_id");
  }

  // Provider ID methods
  Future<void> saveProviderId(String providerId) async {
    await _secureStorage.write(key: "provider_id", value: providerId);
  }

  Future<String?> getProviderId() async {
    return await _secureStorage.read(key: "provider_id");
  }

  Future<void> deleteProviderId() async {
    await _secureStorage.delete(key: "provider_id");
  }

  // Car ID methods
  Future<void> saveCarId(int carId) async {
    await _secureStorage.write(key: "car_id", value: carId.toString());
  }

  Future<int?> getCarId() async {
    String? value = await _secureStorage.read(key: "car_id");
    return value != null ? int.tryParse(value) : null;
  }

  Future<void> deleteCarId() async {
    await _secureStorage.delete(key: "car_id");
  }

  // Method to save all booking data at once - now with integers
  Future<void> saveBookingData({
    int? serviceId,
    String? providerId,
    int? carId,
  }) async {
    if (serviceId != null) await saveServiceId(serviceId);
    if (providerId != null) await saveProviderId(providerId);
    if (carId != null) await saveCarId(carId);
  }

  // Method to get all booking data at once - now returns integers
  Future<Map<String, dynamic>> getAllBookingData() async {
    return {
      'serviceId': await getServiceId(),
      'providerId': await getProviderId(),
      'carId': await getCarId(),
    };
  }

  // Method to clear all booking data
  Future<void> clearAllBookingData() async {
    await deleteServiceId();
    await deleteProviderId();
    await deleteCarId();
  }

  // Helper methods to check if data exists
  Future<bool> hasCompleteBookingData() async {
    Map<String, dynamic> data = await getAllBookingData();
    return data['serviceId'] != null &&
        data['providerId'] != null &&
        data['carId'] != null;
  }

  // Get booking data as a formatted string for debugging
  Future<String> getBookingDataSummary() async {
    Map<String, dynamic> data = await getAllBookingData();
    return 'Service ID: ${data['serviceId'] ?? "Not selected"}, '
        'Provider ID: ${data['providerId'] ?? "Not selected"}, '
        'Car ID: ${data['carId'] ?? "Not selected"}';
  }

}
