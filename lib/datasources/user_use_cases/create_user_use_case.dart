import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

Future<void> createUser(String firstName, String lastName, String userName,
    String email, String password, String confirmationPassword) async {
  try {
    var id = uuid.v4();
    final response = await APIService.instance.request(
      '/api/user', // enter the endpoint for required API call
      DioMethod.post,
      param: {
        "id": id,
        "firstname": firstName,
        "lastname": lastName,
        "username": userName,
        "email": email,
        "password": password,
        "confirmationPassword": confirmationPassword
      },
      contentType: 'application/json',
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Success: Process the response data
      print('API call successful: ${response.data}');
    } else {
      // Error: Handle the error response
      print('API call failed: ${response.statusMessage}');
    }
  } catch (e) {
    // Error: Handle network errors
    print('Network error occurred: $e');
  }
}
