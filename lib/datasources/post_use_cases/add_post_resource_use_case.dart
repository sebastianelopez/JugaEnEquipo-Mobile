import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<void> addPostResource(
    String postId, String mediaId, File resource, bool isVideo) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    // Create form data
    String fileName = resource.path.split('/').last;
    FormData formData = FormData.fromMap({
      'id': mediaId,
      'type': isVideo ? 'video' : 'image',
      'resource': await MultipartFile.fromFile(
        resource.path,
        filename: fileName,
      ),
    });

    final response = await APIService.instance.request(
      '/api/post/$postId/resource',
      DioMethod.post,
      formData: formData,
      contentType: 'multipart/form-data',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Handle the response
    if (response.statusCode == 202) {
      // Success: Process the response data
      if (kDebugMode) {
        debugPrint('API call successful: ${response.data}');
      }
    } else {
      // Error: Handle the error response
      if (kDebugMode) {
        debugPrint('API call failed: ${response.statusMessage}');
      }
    }
  } catch (e) {
    // Error: Handle network errors
    if (kDebugMode) {
      debugPrint('Network error occurred: $e');
    }
  }
}
