import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

/// Update tournament background image
///
/// Parameters:
/// - [tournamentId]: Tournament ID
/// - [image]: Image file to upload
Future<bool> updateTournamentBackgroundImage({
  required String tournamentId,
  required XFile image,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('updateTournamentBackgroundImage: No access token found');
      }
      return false;
    }

    final File imageFile = File(image.path);
    final List<int> imageBytes = await imageFile.readAsBytes();
    final String imageBase64 = base64Encode(imageBytes);

    if (kDebugMode) {
      debugPrint('updateTournamentBackgroundImage: Uploading image...');
      debugPrint('  - Tournament ID: $tournamentId');
      debugPrint('  - Image size (base64): ${imageBase64.length} chars');
    }

    final response = await APIService.instance.request(
      '/api/tournament/$tournamentId/background-image',
      DioMethod.put,
      param: {
        'image': 'data:image/png;base64,$imageBase64',
      },
      contentType: 'application/json',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (kDebugMode) {
      debugPrint('updateTournamentBackgroundImage: Response received');
      debugPrint('  - Status code: ${response.statusCode}');
    }

    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e, stackTrace) {
    if (kDebugMode) {
      debugPrint('updateTournamentBackgroundImage: Error occurred: $e');
      debugPrint('updateTournamentBackgroundImage: Stack trace: $stackTrace');
    }
    return false;
  }
}
