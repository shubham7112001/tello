import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

class ApiClient {
  final Dio dio = Dio();
  
Future<dynamic> post(String endpoint, {Map<String, dynamic>? data, Map<String, dynamic>? headers}) async {
  try {
    debugPrint("post method called\n endpoint: $endpoint\n data: $data");
    final response = await dio.post(
      endpoint,
      data: data,
      options: Options(
        headers: headers,
        followRedirects: false, // prevent auto-following 302
        validateStatus: (status) {
          return status != null && status < 500; // allow 3xx, 4xx
        },
      ),
    );

    return response.data;
  } on DioException catch (e) {
    debugPrint('$e');
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        HelperFunction.showAppSnackBar(
          message: "Network error. Please try again.",
          backgroundColor: Colors.red,
        );
        return null;

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if(e.response?.data['message'] != null){
            HelperFunction.showAppSnackBar(
              message: e.response?.data['message'],
              backgroundColor: Colors.red,
            );
        }else if (statusCode == 401 || statusCode == 403) {
          HelperFunction.showAppSnackBar(
            message: "Unauthorized. Please login again.",
            backgroundColor: Colors.red,
          );
        } else if (statusCode == 404) {
          HelperFunction.showAppSnackBar(
            message: "User not found.",
            backgroundColor: Colors.red,
          );
        } else if (statusCode != null && statusCode >= 500) {
            HelperFunction.showAppSnackBar(
              message: "Server error. Try later.",
              backgroundColor: Colors.red,
            );
        } else {
          HelperFunction.showAppSnackBar(
            message: e.message ?? "Bad request",
            backgroundColor: Colors.red,
          );
        }
        return null;

      case DioExceptionType.badCertificate:
        HelperFunction.showAppSnackBar(
          message: "Invalid SSL Certificate",
          backgroundColor: Colors.red,
        );
        return null;

      case DioExceptionType.cancel:
        HelperFunction.showAppSnackBar(
          message: "Request Cancelled",
          backgroundColor: Colors.red,
        );
        return null;

      default:
        HelperFunction.showAppSnackBar(
          message: "Unexpected error occurred",
          backgroundColor: Colors.red,
        );
        return null;
    }
  } catch (_) {
    HelperFunction.showAppSnackBar(
      message: "Unexpected error occurred",
      backgroundColor: Colors.red,
    );
    return null;
  }
}

}