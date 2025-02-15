import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

Future<List<PostModel>?> getPostsByUserId(String id) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/posts',
      DioMethod.get,
      contentType: 'application/json',
      param: {
        "q": "user:$id",
      },
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Success: Process the response data
      if (kDebugMode) {
        debugPrint('getPostsByUserId - API call successful: ${response.data['data']}');
      }
      final data = response.data['data'];

      if (data is List) {
        final posts = data.map((post) => PostModel.fromJson(post)).toList();
        if (kDebugMode) {
          debugPrint('Parsed posts: $posts');
        }
        return posts;
      } else {
        if (kDebugMode) {
          debugPrint('Data is not a list');
        }
        return null;
      }
    } else {
      // Error: Handle the error response
      if (kDebugMode) {
        debugPrint('getPostsByUserId - API call failed: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    // Error: Handle network errors
    if (kDebugMode) {
      debugPrint('getPostsByUserId - Network error occurredd: $e');
    }
    return null;
  }
}
