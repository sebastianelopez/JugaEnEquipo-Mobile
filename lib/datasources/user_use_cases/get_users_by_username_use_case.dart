import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

Future<List<UserModel>?> getUsersByUsername(
  String username, {
  int? limit,
  int? offset,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final Map<String, dynamic> params = {
      'username': username,
    };

    if (limit != null) {
      params['limit'] = limit;
    }
    if (offset != null) {
      params['offset'] = offset;
    }

    final response = await APIService.instance.request(
      '/api/users',
      DioMethod.get,
      contentType: 'application/json',
      param: params,
      headers: {
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint(
            'getUsersByUsername - API call successful: ${response.data['data']}');
      }

      final responseData = response.data;
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('data')) {
        final data = responseData['data'];
        if (data is List) {
          return data
              .map<UserModel>((dynamic json) =>
                  UserModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }

      if (kDebugMode) {
        debugPrint('getUsersByUsername - Unexpected data format');
      }
      return null;
    } else {
      if (kDebugMode) {
        debugPrint(
            'getUsersByUsername - API call failed: ${response.statusCode} ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getUsersByUsername - Network error occurred: $e');
    }
    return null;
  }
}
