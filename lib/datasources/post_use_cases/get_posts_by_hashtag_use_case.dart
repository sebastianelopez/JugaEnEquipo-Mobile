import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

Future<List<PostModel>?> getPostsByHashtag({
  required String hashtag,
  int limit = 10,
  int offset = 0,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (kDebugMode) {
      debugPrint(
          'getPostsByHashtag - Fetching posts for hashtag: $hashtag with limit: $limit, offset: $offset');
    }

    final cleanHashtag =
        hashtag.startsWith('#') ? hashtag.substring(1) : hashtag;

    final response = await APIService.instance.request(
      '/api/posts/popular/hashtag/$cleanHashtag',
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

    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getPostsByHashtag - API call successful: ${response.data}');
      }
      final data = response.data['data'];

      if (data is List) {
        final posts = data.map((post) => PostModel.fromJson(post)).toList();
        if (kDebugMode) {
          debugPrint('Parsed posts: ${posts.length}');
        }
        return posts;
      } else {
        if (kDebugMode) {
          debugPrint('Data is not a list');
        }
        return null;
      }
    } else {
      if (kDebugMode) {
        debugPrint(
            'getPostsByHashtag - API call failed: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getPostsByHashtag - Network error occurred: $e');
    }
    return null;
  }
}
