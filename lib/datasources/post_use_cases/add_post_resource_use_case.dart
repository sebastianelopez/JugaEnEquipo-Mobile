import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<void> addPostResource(
    String postId, String mediaId, File resource, bool isVideo) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/post/$postId/resource',
      DioMethod.post,
      param: {
        "id": mediaId,
        "resource": resource,
        "type": isVideo ? 'video' : 'image',
      },
      contentType: 'application/json',
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
