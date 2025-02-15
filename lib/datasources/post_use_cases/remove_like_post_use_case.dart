import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

Future<void> removeLikePost(String postId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/post/$postId/dislike',
      DioMethod.put,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Success: Process the response data
      if (kDebugMode) {
        debugPrint('removeLikePost - API call successful: ${response.data}');
      }
    } else {
      // Error: Handle the error response
      if (kDebugMode) {
        debugPrint(
            'removeLikePost - API call failed: ${response.statusMessage}');
      }
    }
  } catch (e) {
    // Error: Handle network errors
    if (kDebugMode) {
      debugPrint('removeLikePost - Network error occurred: $e');
    }
  }
}