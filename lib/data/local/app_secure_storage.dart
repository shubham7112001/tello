
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:otper_mobile/configs/app_config.dart';

class AppSecureStorage {
  final _storage = const FlutterSecureStorage();
  final _appConfig = AppConfig();

  Future setToken(String token) async {
    await _storage.write(key: _appConfig.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _appConfig.tokenKey);
  }

  Future setEmail(String email) async {
    await _storage.write(key: _appConfig.emailKey, value: email);
  }

  Future<String?> getEmail() async {
    return await _storage.read(key: _appConfig.emailKey);
  }
}