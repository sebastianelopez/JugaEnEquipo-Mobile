import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

Future<List<PostModel>?> getFeedByUserId({
  int limit = 10,
  int offset = 0,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (kDebugMode) {
      debugPrint(
          'getFeedByUserId - Fetching feed with limit: $limit, offset: $offset');
    }

    final response = await APIService.instance.request(
      '/api/my-feed',
      DioMethod.get,
      contentType: 'application/json',
      param: {
        'limit': limit.toString(),
        'offset': offset.toString(),
      },
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Manejar la respuesta
    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint(
            'getFeedByUserId - API call successful: ${response.data['data']}');
      }
      final data = response.data['data'];

      // Debug: Check if data is a list
      if (data is List) {
        final posts = data.map((post) => PostModel.fromJson(post)).toList();
        if (kDebugMode) {
          debugPrint('Data is a list');
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
      // Error: Manejar la respuesta de error
      if (kDebugMode) {
        debugPrint(
            'getFeedByUserId - API call failed: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    // Error: Manejar errores de red
    if (kDebugMode) {
      debugPrint('getFeedByUserId - Network error occurred: $e');
    }
    return null;
  }
}
