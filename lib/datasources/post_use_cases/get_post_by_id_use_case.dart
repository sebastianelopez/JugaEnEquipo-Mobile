import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

Future<PostModel?> getPostById(String id) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/post/$id',
      DioMethod.get,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Success: Process the response data
      if (kDebugMode) {
        debugPrint(
            'getPostById- API call successful: ${response.data['data']}');
      }
      return PostModel.fromJson(response.data['data']);
    } else {
      // Error: Handle the error response
      if (kDebugMode) {
        debugPrint('getPostById - API call failed: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    // Error: Handle network errors
    if (kDebugMode) {
      debugPrint('getPostById - Network error occurredd: $e');
    }
    return null;
  }
}
