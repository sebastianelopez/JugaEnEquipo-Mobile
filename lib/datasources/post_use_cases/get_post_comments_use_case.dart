import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

Future<List<CommentModel>?> getPostComments(String postId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/post/$postId/comments',
      DioMethod.get,
      param: {
        'limit': 100,
        'offset': 0,
      },
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Check if response.data is null
      if (response.data == null) {
        if (kDebugMode) {
          debugPrint('getPostComments - Response data is null');
        }
        return [];
      }

      final data = response.data['data'];

      // Check if data is a list
      if (data is List) {
        final comments = data.map((comment) {
          return CommentModel.fromJson(comment);
        }).toList();
        return comments;
      } else {
        if (kDebugMode) {
          debugPrint(
              'getPostComments - Unexpected data format, expected List but got ${data.runtimeType}');
        }
        return [];
      }
    } else {
      // Error: Handle the error response
      if (kDebugMode) {
        debugPrint(
            'getPostComments - API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return [];
    }
  } catch (e, stackTrace) {
    // Error: Handle network errors
    if (kDebugMode) {
      debugPrint('getPostComments - Error occurred: $e');
      debugPrint('getPostComments - Stack trace: $stackTrace');
    }
    return [];
  }
}
