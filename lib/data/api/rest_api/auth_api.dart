import 'package:flutter/material.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';
import 'package:otper_mobile/data/api/rest_api/api_client.dart';
import 'package:otper_mobile/data/api/rest_api/api_endpoints.dart';
import 'package:otper_mobile/data/db/auth_db/auth_db.dart';
import 'package:otper_mobile/data/db/auth_db/auth_db_helper.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

class AuthApi {
  final ApiClient apiClient = ApiClient();

  Future<Map<String, dynamic>> login(String email, String password) async {

    Map<String, String> mapData = {
      "email": email,
      "password": password,
    };
    debugPrint("Auth Api login called");
    final response =  await apiClient.post(
      ApiEndpoints.login,
      data: mapData,
    );
    if(response['status'] == 'success') {
      await AuthDbHelper.instance.insertLogin(email: email, token: response['token']);
      AppNavigator.goToHome(clearStack: true);
    }
    return response;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String username,
    required String password,
    required String passwordConfirmation,
  }) async {
    Map<String, String> mapData = {
      "name": name,
      "email": email,
      "username": username,
      "password": password,
      "password_confirmation": passwordConfirmation,
    };

    debugPrint("Auth Api register called");

    final response = await apiClient.post(
      ApiEndpoints.register,
      data: mapData,
    );

    return response;
}

Future<Map<String, dynamic>> logout() async {
  debugPrint("Auth Api logout called");

  try {
    final LoginTableDriftData? data = await AuthDbHelper.instance.getLatestLogin();
    debugPrint("Login Data: $data");

    if (data?.token != null) {
      final token = 'Bearer ${data!.token}';

      final response = await apiClient.post(
        ApiEndpoints.logout,
        headers: {
          "Authorization": token,
          "Accept": "application/json",
        },
      );

      debugPrint("Logout Response: $response");

      if (response['status'] == 'success') {
        await AuthDbHelper.instance.deleteAllLogins();
        AppNavigator.goToLogin(clearStack: true);
      } else {
        HelperFunction.showAppSnackBar(
          message: response['message'] ?? "Logout failed",
        );
        AppNavigator.goToLogin(clearStack: true);
      }

      return response;
    }
  } catch (e) {
    HelperFunction.showAppSnackBar(message: "Error while logging out");
  }

  return {
    "status": "error",
    "message": "No active session found",
  };
}
}