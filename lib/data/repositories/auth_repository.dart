import 'package:flutter/material.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';
import 'package:otper_mobile/data/api/api_exception.dart';
import 'package:otper_mobile/data/api/rest_api/auth_api.dart';
import 'package:otper_mobile/data/local/app_secure_storage.dart';

class AuthRepository {
  final authApi = AuthApi();
  final appSecureStorage = AppSecureStorage();
  
  Future<void> login(String email, String password) async {
    debugPrint("Login Api Called");
    try {
      Map<String, dynamic> responseData = await authApi.login(email, password);

      if(responseData["status"] == "success"){
        debugPrint("Response success");
        List<Future> futures = [];
        futures.add(appSecureStorage.setEmail(email));
        futures.add(appSecureStorage.setToken(responseData["token"]));
        await Future.wait(futures);
        AppNavigator.goToHome(clearStack: true);
      }else{
        debugPrint("Data comes with status fail");
      }
      
    } on UserNotFoundException{
      rethrow;
    } on NetworkException {
      rethrow; // Let BLoC handle network issues
    } on AuthException {
      rethrow; // Unauthorized or forbidden
    } on ServerException {
      rethrow; // 5xx or unexpected server issue
    } on BadRequestException {
      rethrow; // 4xx client error
    } catch (_) {
      throw const ServerException("Unknown login error");
    }
  }
}
