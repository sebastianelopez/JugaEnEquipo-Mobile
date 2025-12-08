import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

Future<bool> addPostComment(String postId, String comment) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    var id = uuid.v4();

    final response = await APIService.instance.request(
      '/api/post/$postId/comment',
      DioMethod.put,
      param: {"commentId": id, "commentBody": comment},
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Success: Process the response data
      if (kDebugMode) {
        debugPrint('addPostComment - API call successful: ${response.data}');
      }
      return true;
    } else {
      // Error: Handle the error response
      if (kDebugMode) {
        debugPrint(
            'addPostComment - API call failed: ${response.statusMessage}');
      }
      return false;
    }
  } catch (e) {
    // Error: Handle network errors
    if (kDebugMode) {
      debugPrint('addPostComment - Network error occurred: $e');
    }
    return false;
  }
}
