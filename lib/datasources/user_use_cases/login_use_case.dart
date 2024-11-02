import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


Future<Result> login(String email, String password) async {
  try {
    final response = await APIService.instance.request(
      '/api/login', 
      DioMethod.post,
      param: {"email": email, "password": password},
      contentType: 'application/json',
    );

    switch (response.statusCode) {
      case 200:
        // Success: Process the response data
        print('API call successful: ${response.data['data']['token']}');

        const storage = FlutterSecureStorage();
        await storage.write(key: 'access_token', value: await response.data['data']['token']);
        await storage.write(
            key: 'refresh_token', value: await response.data['data']['refreshToken']);  

        return Result.success;
      case 401:
        // Unauthorized: Return custom error message
        return Result.unauthorized;
      default:
        // Handle other errors (consider adding specific error handling for common cases)
        print('API call failed with status code: ${response.statusCode}');
        print('Error: ${response.statusMessage}');
        return Result.error;
    }
  } catch (e) {
    // Network error occurred: Log and return error
    print('Network error occurred: $e');
    return Result.error;
  }
}
