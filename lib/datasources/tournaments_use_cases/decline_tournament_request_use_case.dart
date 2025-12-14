import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Decline a tournament request
///
/// Parameters:
/// - [requestId]: Request ID to decline
Future<bool> declineTournamentRequest({
  required String requestId,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('declineTournamentRequest: No access token found');
      }
      return false;
    }

    if (kDebugMode) {
      debugPrint('declineTournamentRequest: Declining request $requestId');
    }

    final response = await APIService.instance.request(
      '/api/tournament/request/$requestId/decline',
      DioMethod.put,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (kDebugMode) {
      debugPrint('declineTournamentRequest: Response received');
      debugPrint('  - Status code: ${response.statusCode}');
      debugPrint('  - Response data: ${response.data}');
    }

    return response.statusCode == 200 || 
           response.statusCode == 201 || 
           response.statusCode == 204;
  } catch (e, stackTrace) {
    if (kDebugMode) {
      debugPrint('declineTournamentRequest: Error occurred: $e');
      debugPrint('declineTournamentRequest: Stack trace: $stackTrace');
    }
    return false;
  }
}
