import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Update team background image
/// 
/// Parameters:
/// - [teamId]: The ID of the team
/// - [imageFile]: The image file to upload (will be converted to base64 data URI)
Future<Result> updateTeamBackgroundImage(String teamId, File imageFile) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('updateTeamBackgroundImage: No access token found');
      }
      return Result.error;
    }

    // Read image file and convert to base64
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);
    
    // Determine MIME type
    String mimeType = 'image/png';
    final extension = imageFile.path.split('.').last.toLowerCase();
    if (extension == 'jpg' || extension == 'jpeg') {
      mimeType = 'image/jpeg';
    } else if (extension == 'gif') {
      mimeType = 'image/gif';
    }
    
    // Create data URI
    final dataUri = 'data:$mimeType;base64,$base64Image';

    final response = await APIService.instance.request(
      '/api/team/$teamId/background-image',
      DioMethod.put,
      param: {'image': dataUri},
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (kDebugMode) {
        debugPrint('updateTeamBackgroundImage: API call successful');
      }
      return Result.success;
    } else if (response.statusCode == 401) {
      if (kDebugMode) {
        debugPrint('updateTeamBackgroundImage: Unauthorized - invalid token');
      }
      return Result.unauthorized;
    } else {
      if (kDebugMode) {
        debugPrint(
            'updateTeamBackgroundImage: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return Result.error;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('updateTeamBackgroundImage: Network error occurred: $e');
    }
    return Result.error;
  }
}

