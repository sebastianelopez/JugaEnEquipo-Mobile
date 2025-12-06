import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

/// Get all tournament statuses
Future<List<TournamentStatusModel>?> getTournamentStatuses() async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('getTournamentStatuses: No access token found');
      }
      return null;
    }

    final response = await APIService.instance.request(
      '/api/tournament-status',
      DioMethod.get,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getTournamentStatuses: API call successful');
      }

      if (response.data == null) {
        if (kDebugMode) {
          debugPrint('getTournamentStatuses: Response data is null');
        }
        return null;
      }

      final data = response.data['data'];
      if (data == null || data is! List) {
        if (kDebugMode) {
          debugPrint('getTournamentStatuses: Response data is not a list');
        }
        return null;
      }

      try {
        final statuses = data
            .map((status) => TournamentStatusModel.fromJson(
                status as Map<String, dynamic>))
            .toList();
        return statuses;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('getTournamentStatuses: Error parsing response: $e');
        }
        return null;
      }
    } else {
      if (kDebugMode) {
        debugPrint(
            'getTournamentStatuses: API call failed with status ${response.statusCode}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getTournamentStatuses: Network error occurred: $e');
    }
    return null;
  }
}



