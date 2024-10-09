import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

Future<List<PostModel>?> getPostsByUserId(String id) async {
  try {
    final storage = FlutterSecureStorage();
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
      print('API call successful: ${response.data['data']}');
      final data = response.data['data'];

      // Debug: Check if data is a list
      if (data is List) {
        print('Data is a list');
        final posts = data.map((post) => PostModel.fromJson(post)).toList();
        print('Parsed posts: $posts');
        return posts;
      } else {
        print('Data is not a list');
        return null;
      }
    } else {
      // Error: Manejar la respuesta de error
      print('API call failed: ${response.statusMessage}');
      return null;
    }
  } catch (e) {
    // Error: Manejar errores de red
    print('Network error occurred: $e');
    return null;
  }
}
