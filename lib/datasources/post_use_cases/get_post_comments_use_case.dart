import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

Future<List<CommentModel>?> getPostComments(String postId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    debugPrint(postId);

    final response = await APIService.instance.request(
      '/api/post/$postId/comments',
      DioMethod.get,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Success: Process the response data
      if (kDebugMode) {
        debugPrint('getPostComments - API call successful: ${response.data}');
      }
      final data = response.data['data'];
      // Debug: Check if data is a list
      if (data is List) {
        final comments =
            data.map((comment) => CommentModel.fromJson(comment)).toList();
        if (kDebugMode) {
          debugPrint('getPostComments - Parsed comments: $comments');
        }
        return comments;
      } else {
        if (kDebugMode) {
          debugPrint('getPostComments - Data is not a list');
        }
        return null;
      }
    } else {
      // Error: Handle the error response
      if (kDebugMode) {
        debugPrint(
            'getPostComments - API call failed: ${response.statusMessage}');
      }
    }
  } catch (e) {
    // Error: Handle network errors
    if (kDebugMode) {
      debugPrint('getPostComments - Network error occurred: $e');
    }
  }
  return null;
}
