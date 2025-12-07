import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Accept a tournament request
///
/// Parameters:
/// - [requestId]: Request ID to accept
Future<bool> acceptTournamentRequest({
  required String requestId,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('acceptTournamentRequest: No access token found');
      }
      return false;
    }

    if (kDebugMode) {
      debugPrint('acceptTournamentRequest: Accepting request $requestId');
    }

    final response = await APIService.instance.request(
      '/api/tournament/request/$requestId/accept',
      DioMethod.put,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (kDebugMode) {
      debugPrint('acceptTournamentRequest: Response received');
      debugPrint('  - Status code: ${response.statusCode}');
    }

    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e, stackTrace) {
    if (kDebugMode) {
      debugPrint('acceptTournamentRequest: Error occurred: $e');
      debugPrint('acceptTournamentRequest: Stack trace: $stackTrace');
    }
    return false;
  }
}
