import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

Future<UserModel?> getUserById(String id) async {
  try {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    final response = await APIService.instance.request(
      '/api/user/$id',
      DioMethod.get,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Manage the response
    if (response.statusCode == 200) {
      print('API call successful: ${response.data['data']}');
      return UserModel.fromJson(response.data['data']);
    } else {
      // Error: Manage the error response
      print('API call failed: ${response.statusMessage}');
      return null;
    }
  } catch (e) {
    // Error: Manage network errors
    print('Network error occurred: $e');
    return null;
  }
}
