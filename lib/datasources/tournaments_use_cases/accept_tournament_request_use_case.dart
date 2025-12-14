import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Accept a tournament request
///
/// Parameters:
/// - [requestId]: Request ID to accept
///
/// Returns:
/// - Map with 'success' (bool) and optional 'errorMessage' (String)
Future<Map<String, dynamic>> acceptTournamentRequest({
  required String requestId,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('acceptTournamentRequest: No access token found');
      }
      return {
        'success': false,
        'errorMessage': 'No se encontró el token de acceso',
      };
    }

    if (kDebugMode) {
      debugPrint('acceptTournamentRequest: Accepting request $requestId');
    }

    final response = await APIService.instance.request(
      '/api/tournament/request/$requestId/accept',
      DioMethod.put,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (kDebugMode) {
      debugPrint('acceptTournamentRequest: Response received');
      debugPrint('  - Status code: ${response.statusCode}');
      debugPrint('  - Response data: ${response.data}');
    }

    final isSuccess = response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204;

    if (isSuccess) {
      return {'success': true};
    } else {
      // Extract error message from response
      String errorMessage = 'Error al aceptar la solicitud';
      if (response.data != null && response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('message')) {
          errorMessage = data['message'] as String;
        }
      }
      return {
        'success': false,
        'errorMessage': errorMessage,
      };
    }
  } catch (e, stackTrace) {
    if (kDebugMode) {
      debugPrint('acceptTournamentRequest: Error occurred: $e');
      debugPrint('acceptTournamentRequest: Stack trace: $stackTrace');
    }
    return {
      'success': false,
      'errorMessage': 'Error de conexión. Por favor, intenta nuevamente.',
    };
  }
}
