import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final TokenStorage _instance = TokenStorage._internal();
  factory TokenStorage() => _instance;
  TokenStorage._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: "token", value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: "token");
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: "token");
  }
}
