import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:uuid/uuid.dart';

Future<Result> createPost(
    String text, List<String>? imageIds, String id) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    var id = uuid.v4();

    final response = await APIService.instance.request(
      '/api/post', // enter the endpoint for required API call
      DioMethod.post,
      param: {
        "id": id,
        "body": text,
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
