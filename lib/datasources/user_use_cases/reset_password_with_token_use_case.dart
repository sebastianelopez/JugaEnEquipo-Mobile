import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<Result> resetPasswordWithToken(
    String token, String newPassword, String confirmationPassword) async {
  try {
    final response = await APIService.instance.request(
      '/api/auth/reset-password',
      DioMethod.post,
      param: {
        'token': token,
        'password': newPassword,
        'password_confirmation': confirmationPassword,
      },
      contentType: 'application/json',
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('resetPasswordWithToken: Password reset successfully');
      }
      return Result.success;
    } else if (response.statusCode == 401) {
      if (kDebugMode) {
        debugPrint('resetPasswordWithToken: Invalid or expired token');
      }
      return Result.unauthorized;
    } else {
      if (kDebugMode) {
        debugPrint(
            'resetPasswordWithToken: API call failed: ${response.statusMessage}');
      }
      return Result.error;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('resetPasswordWithToken: Network error occurred: $e');
    }
    return Result.error;
  }
}

