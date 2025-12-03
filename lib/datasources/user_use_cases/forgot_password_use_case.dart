import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<Result> forgotPassword(String email) async {
  try {
    final response = await APIService.instance.request(
      '/api/auth/forgot-password',
      DioMethod.post,
      param: {'email': email},
      contentType: 'application/json',
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('forgotPassword: Email sent successfully');
      }
      return Result.success;
    } else {
      if (kDebugMode) {
        debugPrint(
            'forgotPassword: API call failed: ${response.statusMessage}');
      }
      return Result.error;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('forgotPassword: Network error occurred: $e');
    }
    return Result.error;
  }
}

