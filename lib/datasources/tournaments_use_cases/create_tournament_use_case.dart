import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:uuid/uuid.dart';

/// Create or update a tournament
///
/// Parameters:
/// - [tournamentId]: Tournament ID (if null, a new one will be generated for creation)
/// - [name]: Tournament name
/// - [description]: Tournament description
/// - [rules]: Tournament rules
/// - [gameId]: Game ID
/// - [region]: Tournament region
/// - [maxTeams]: Maximum number of teams
/// - [startAt]: Start date and time
/// - [endAt]: End date and time
/// - [responsibleId]: ID of the responsible user
/// - [minGameRankId]: Optional minimum rank ID
/// - [maxGameRankId]: Optional maximum rank ID
/// - [image]: Optional tournament image file (will be uploaded separately)
Future<Map<String, dynamic>?> createTournament({
  String? tournamentId,
  required String name,
  required String description,
  required String rules,
  required String gameId,
  required String region,
  required int maxTeams,
  required DateTime startAt,
  required DateTime endAt,
  required String responsibleId,
  String? minGameRankId,
  String? maxGameRankId,
  XFile? image,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('createTournament: No access token found');
      }
      return null;
    }

    final finalTournamentId = tournamentId ?? const Uuid().v4();
    final isUpdate = tournamentId != null;

    if (kDebugMode) {
      debugPrint(
          'createTournament: ${isUpdate ? "Updating" : "Creating"} tournament...');
      debugPrint('  - Tournament ID: $finalTournamentId');
      debugPrint('  - Name: $name');
      debugPrint('  - Game ID: $gameId');
      debugPrint('  - Region: $region');
      debugPrint('  - Max Teams: $maxTeams');
      debugPrint('  - Responsible ID: $responsibleId');
      debugPrint('  - Has background image to upload later: ${image != null}');
    }

    final Map<String, dynamic> payload = {
      'gameId': gameId,
      'responsibleId': responsibleId,
      'name': name,
      'description': description,
      'rules': rules,
      'maxTeams': maxTeams,
      'isOfficial': false, // Always false for amateur tournaments
      'prize': null, // null for amateur tournaments
      'region': region,
      'startAt': startAt.toIso8601String(),
      'endAt': endAt.toIso8601String(),
      if (minGameRankId != null) 'minGameRankId': minGameRankId,
      if (maxGameRankId != null) 'maxGameRankId': maxGameRankId,
      'image': null, // Always null, use separate endpoint for background image
    };

    if (kDebugMode) {
      debugPrint('createTournament: Payload: $payload');
    }

    final response = await APIService.instance.request(
      '/api/tournament/$finalTournamentId',
      DioMethod.put,
      param: payload,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (kDebugMode) {
      debugPrint('createTournament: Response received');
      debugPrint('  - Status code: ${response.statusCode}');
      debugPrint('  - Response data: ${response.data}');
    }

    if (response.statusCode == 201 || response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint(
            'createTournament: Tournament ${isUpdate ? "updated" : "created"} successfully');
      }

      // Backend returns empty response or HTML, so we return the tournament ID
      // that we generated/used for future reference
      if (response.data is Map<String, dynamic>) {
        final result = response.data as Map<String, dynamic>;
        result['tournamentId'] = finalTournamentId;
        return result;
      } else {
        return {
          'id': finalTournamentId,
          'tournamentId': finalTournamentId,
          'name': name,
          'success': true,
        };
      }
    } else {
      if (kDebugMode) {
        debugPrint(
            'createTournament: Failed with status ${response.statusCode}');
        debugPrint('  - Response message: ${response.statusMessage}');
        debugPrint('  - Response data: ${response.data}');
      }
      return null;
    }
  } catch (e, stackTrace) {
    if (kDebugMode) {
      debugPrint('createTournament: Error occurred: $e');
      debugPrint('createTournament: Stack trace: $stackTrace');
    }
    return null;
  }
}
