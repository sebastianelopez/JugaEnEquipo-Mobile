import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

/// Update team information
///
/// Parameters:
/// - [teamId]: The ID of the team to update
/// - [name]: New team name (optional)
/// - [description]: New team description (optional)
/// - [image]: Base64 encoded image data URI (optional)
Future<TeamModel?> updateTeam({
  required String teamId,
  String? name,
  String? description,
  String? image,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('updateTeam: No access token found');
      }
      return null;
    }

    final Map<String, dynamic> body = {};
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;
    if (image != null) body['image'] = image;

    final response = await APIService.instance.request(
      '/api/team/$teamId',
      DioMethod.put,
      param: body,
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('updateTeam: API call successful');
      }

      if (response.data == null) {
        if (kDebugMode) {
          debugPrint('updateTeam: Response data is null');
        }
        return null;
      }

      try {
        if (kDebugMode) {
          debugPrint(
              'updateTeam: response.data type: ${response.data.runtimeType}');
          debugPrint('updateTeam: response.data: ${response.data}');
        }

        dynamic data;

        // Handle different response structures
        if (response.data is Map<String, dynamic>) {
          // Standard structure: { "data": {...} }
          data = response.data['data'] ?? response.data;
        } else if (response.data is List) {
          // If response.data is a list, it's likely the team data directly
          if (kDebugMode) {
            debugPrint(
                'updateTeam: response.data is a List, taking first element');
          }
          if ((response.data as List).isNotEmpty) {
            data = (response.data as List)[0];
          } else {
            if (kDebugMode) {
              debugPrint('updateTeam: response.data is an empty List');
            }
            return null;
          }
        } else {
          // Fallback: use response.data directly
          data = response.data;
        }

        if (kDebugMode) {
          debugPrint('updateTeam: Final data type: ${data.runtimeType}');
          debugPrint('updateTeam: Final data: $data');
        }

        // Ensure data is a Map
        if (data is! Map<String, dynamic>) {
          if (kDebugMode) {
            debugPrint(
                'updateTeam: Data is not a Map, type: ${data.runtimeType}');
          }
          return null;
        }

        return TeamModel.fromJson(data);
      } catch (e, stackTrace) {
        if (kDebugMode) {
          debugPrint('updateTeam: Error parsing response: $e');
          debugPrint('updateTeam: Stack trace: $stackTrace');
          debugPrint(
              'updateTeam: Response data type: ${response.data.runtimeType}');
          debugPrint('updateTeam: Response data: ${response.data}');
        }
        return null;
      }
    } else {
      if (kDebugMode) {
        debugPrint(
            'updateTeam: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('updateTeam: Network error occurred: $e');
    }
    return null;
  }
}
