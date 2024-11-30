import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<void> addPostResource(String postId, String mediaId, File resource, bool isVideo) async {
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
      print('API call successful: ${response.data}');
    } else {
      // Error: Handle the error response
      print('API call failed: ${response.statusMessage}');
    }
  } catch (e) {
    // Error: Handle network errors
    print('Network error occurred: $e');
  }
}
