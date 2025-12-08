import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

Future<List<CommentModel>?> getPostComments(String postId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (kDebugMode) {
      debugPrint('getPostComments - Fetching comments for postId: $postId');
    }

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

    if (kDebugMode) {
      debugPrint('getPostComments - Response status: ${response.statusCode}');
      debugPrint(
          'getPostComments - Response data type: ${response.data.runtimeType}');
      debugPrint('getPostComments - Full response: ${response.data}');
    }

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

      if (kDebugMode) {
        debugPrint('getPostComments - Data type: ${data.runtimeType}');
        debugPrint('getPostComments - Data content: $data');
      }

      // Debug: Check if data is a list
      if (data is List) {
        if (kDebugMode) {
          debugPrint('getPostComments - Found ${data.length} comments');
        }

        final comments = data.map((comment) {
          if (kDebugMode) {
            debugPrint('getPostComments - Parsing comment: $comment');
          }
          return CommentModel.fromJson(comment);
        }).toList();

        if (kDebugMode) {
          debugPrint(
              'getPostComments - Successfully parsed ${comments.length} comments');
        }
        return comments;
      } else {
        if (kDebugMode) {
          debugPrint(
              'getPostComments - Data is not a list, returning empty list');
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
