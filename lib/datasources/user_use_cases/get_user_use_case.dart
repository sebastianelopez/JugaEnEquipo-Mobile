import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

Future<UserModel?> getUserById(String id) async {
  try {
    final response = await APIService.instance.request(
      '/api/user/$id',
      DioMethod.get,
      contentType: 'application/json',
    );

    // Manejar la respuesta
    if (response.statusCode == 200) {
      print('API call successful: ${response.data['data']}');
      return UserModel.fromJson(response.data['data']);
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
