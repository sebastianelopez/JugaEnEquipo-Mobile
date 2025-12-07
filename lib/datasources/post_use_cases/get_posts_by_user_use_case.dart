import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

Future<List<PostModel>?> getPostsByUserId(String id) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (kDebugMode) {
      debugPrint('getPostsByUserId - Requesting posts for user: $id');
      debugPrint('getPostsByUserId - Endpoint: /api/posts?userId=$id');
    }

    final response = await APIService.instance.request(
      '/api/posts',
      DioMethod.get,
      contentType: 'application/json',
      param: {
        "userId": id,
      },
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Success: Process the response data
      if (kDebugMode) {
        debugPrint('getPostsByUserId - API call successful');
        debugPrint(
            'getPostsByUserId - Response status: ${response.statusCode}');
        debugPrint(
            'getPostsByUserId - Response data type: ${response.data.runtimeType}');
        debugPrint('getPostsByUserId - Response data: ${response.data}');
      }
      final data = response.data['data'];

      if (data is List) {
        final posts = data.map((post) => PostModel.fromJson(post)).toList();
        if (kDebugMode) {
          debugPrint(
              'getPostsByUserId - Successfully parsed ${posts.length} posts');
        }
        return posts;
      } else {
        if (kDebugMode) {
          debugPrint(
              'getPostsByUserId - Data is not a list, type: ${data.runtimeType}');
        }
        return null;
      }
    } else {
      // Error: Handle the error response
      if (kDebugMode) {
        debugPrint(
            'getPostsByUserId - API call failed with status: ${response.statusCode}');
        debugPrint(
            'getPostsByUserId - Error message: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e, stackTrace) {
    // Error: Handle network errors
    if (kDebugMode) {
      debugPrint('getPostsByUserId - Network error occurred: $e');
      debugPrint('getPostsByUserId - Stack trace: $stackTrace');
    }
    return null;
  }
}
