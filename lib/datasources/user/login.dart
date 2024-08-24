import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<bool> login(String email, String password) async {
  try {
    final response = await APIService.instance.request(
      '/api/login', // enter the endpoint for required API call
      DioMethod.post,
      param: {"email": email, "password": password},
      contentType: 'application/json',
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Success: Process the response data
      print('API call successful: ${response.data}');

      const storage = FlutterSecureStorage();
      await storage.write(key: 'access_token', value: response.data['token']);
      await storage.write(key: 'refresh_token', value: response.data['refreshToken']);

      return true; 
    } else {
      // Error: Handle the error response
      print('API call failed: ${response.statusMessage}');

      return false; 
    }
  } catch (e) {
    // Error: Handle network errors
    print('Network error occurred: $e');

    return false; 
  }
}
