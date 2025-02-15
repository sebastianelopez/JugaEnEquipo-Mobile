import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/utils/utils.dart';

Future<List<TeamModel>?> getInitialTeams() async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/teams',
      DioMethod.get,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Manage data
    if (response.statusCode == 200) {
      debugLog(
          'getInitialTeams - API call successful: ${response.data['data']}');
      final data = response.data['data'];

      // Debug: Check if data is a list
      if (data is List) {
        debugLog('Data is a list');
        final teams = data.map((team) => TeamModel.fromJson(team)).toList();
        debugLog('Parsed posts: $teams');
        return teams;
      } else {
        debugLog('Data is not a list');
        return null;
      }
    } else {
      // Error: Manage error response
      debugLog('getInitialTeams - API call failed: ${response.statusMessage}');
      return null;
    }
  } catch (e) {
    // Error: Manage network errors
    debugLog('getInitialTeams - Network error occurredd: $e');
    return null;
  }
}
