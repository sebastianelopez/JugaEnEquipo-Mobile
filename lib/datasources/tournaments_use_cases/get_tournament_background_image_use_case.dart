import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Get tournament background image
///
/// Parameters:
/// - [tournamentId]: Tournament ID
///
/// Returns the background image URL or null if not available
Future<String?> getTournamentBackgroundImage({
  required String tournamentId,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('getTournamentBackgroundImage: No access token found');
      }
      return null;
    }

    final response = await APIService.instance.request(
      '/api/tournament/$tournamentId/background-image',
      DioMethod.get,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (kDebugMode) {
      debugPrint('getTournamentBackgroundImage: Response received');
      debugPrint('  - Status code: ${response.statusCode}');
      debugPrint('  - Response data: ${response.data}');
    }

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'];
      if (data != null && data['backgroundImage'] != null) {
        return data['backgroundImage'] as String;
      }
    }

    return null;
  } catch (e, stackTrace) {
    if (kDebugMode) {
      debugPrint('getTournamentBackgroundImage: Error occurred: $e');
      debugPrint('getTournamentBackgroundImage: Stack trace: $stackTrace');
    }
    return null;
  }
}
