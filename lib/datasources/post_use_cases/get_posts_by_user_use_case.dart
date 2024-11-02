import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/utils/utils.dart';

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

    // Manejar la respuesta
    if (response.statusCode == 200) {
      debugLog('API call successful: ${response.data['data']}');
      final data = response.data['data'];

      // Debug: Check if data is a list
      if (data is List) {
        debugLog('Data is a list');
        final posts = data.map((post) => PostModel.fromJson(post)).toList();
        debugLog('Parsed posts: $posts');
        return posts;
      } else {
        debugLog('Data is not a list');
        return null;
      }
    } else {
      // Error: Manejar la respuesta de error
      debugLog('API call failed: ${response.statusMessage}');
      return null;
    }
  } catch (e) {
    // Error: Manejar errores de red
    debugLog('Network error occurredd: $e');
    return null;
  }
}
