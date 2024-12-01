import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:uuid/uuid.dart';
import 'package:mime_type/mime_type.dart';

var uuid = const Uuid();

Future<Result> updateUserProfileImage(String userId, File profileImage) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null) {
      if (kDebugMode) {
        debugPrint('Access token is null');
      }
      return Result.error;
    }
    final FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        profileImage.path,
        filename: '${uuid.v4()}.${mime(profileImage.path)}',
      ),
    });

    final response = await APIService.instance.request(
      '/api/user/profile-image/$userId',
      DioMethod.post,
      formData: formData,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Success: Process the response data
      if (kDebugMode) {
        debugPrint('Imagen subida cone exito');
      }
      return Result.success;
    } else {
      // Error: Handle the error response
      if (kDebugMode) {
        debugPrint('API call failed: ${response.statusMessage}');
      }
      return Result.error;
    }
  } catch (e) {
    // Error: Handle network errors
    if (e is DioError) {
      if (e.response?.data != null && kDebugMode) {
        debugPrint('Error details: ${e.response?.data}');
      }
      return Result.error;
    } else {
      if (kDebugMode) {
        debugPrint('Network error occurred: $e');
      }
      return Result.error;
    }
  }
}
