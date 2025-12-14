import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<List<String>?> getPopularHashtags() async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (kDebugMode) {
      debugPrint('getPopularHashtags - Fetching popular hashtags');
    }

    final response = await APIService.instance.request(
      '/api/post/hashtag/popular',
      DioMethod.get,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint(
            'getPopularHashtags - API call successful: ${response.data}');
      }
      final data = response.data['data'];

      if (data is List) {
        final hashtags = data.map((item) => item.toString()).toList();
        if (kDebugMode) {
          debugPrint('Parsed hashtags: $hashtags');
        }
        return hashtags;
      } else {
        if (kDebugMode) {
          debugPrint('Data is not a list');
        }
        return null;
      }
    } else {
      if (kDebugMode) {
        debugPrint(
            'getPopularHashtags - API call failed: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getPopularHashtags - Network error occurred: $e');
    }
    return null;
  }
}
