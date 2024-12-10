import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<Result> createPost(
    String text, List<String>? imageIds, String id) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/post/$id',
      DioMethod.put,
      param: {
        "body": text,
        "resources": [],
      },
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Success: Process the response data
      if (kDebugMode) {
        debugPrint('API call successful: ${response.data}');
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
    if (kDebugMode) {
      debugPrint('Network error occurred: $e');
    }
    return Result.error;
  }
}
