import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

Future<void> createTeam(String name, String game) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    var id = uuid.v4();

    final response = await APIService.instance.request(
      '/api/team', // enter the endpoint for required API call
      DioMethod.post,
      param: {
        "id": id,
        "name": name,
        "game": game,
      },
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Success: Process the response data
      if (kDebugMode) {
        debugPrint('API call successful: ${response.data}');
      }
    } else {
      // Error: Handle the error response
      if (kDebugMode) {
        debugPrint('API call failed: ${response.statusMessage}');
      }
    }
  } catch (e) {
    // Error: Handle network errors
    if (kDebugMode) {
      debugPrint('Network error occurred: $e');
    }
  }
}
