import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<String?> getUserBackgroundImage(String userId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/user/$userId/background-image',
      DioMethod.get,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getUserBackgroundImage: API call successful');
        debugPrint('getUserBackgroundImage: Response data: ${response.data}');
      }
      // The response structure is: { "data": { "backgroundImage": "url" } }
      String? imageUrl;
      if (response.data is Map) {
        final data = response.data['data'];
        if (data is Map) {
          imageUrl = data['backgroundImage'] as String?;
        } else if (data is String) {
          // Fallback: if data is directly a string
          imageUrl = data;
        }
      } else if (response.data is String) {
        // Fallback: if response is directly a string
        imageUrl = response.data as String;
      }

      if (kDebugMode) {
        debugPrint('getUserBackgroundImage: Extracted URL: $imageUrl');
      }

      return imageUrl;
    } else {
      if (kDebugMode) {
        debugPrint(
            'getUserBackgroundImage: API call failed: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getUserBackgroundImage: Network error occurred: $e');
    }
    return null;
  }
}
