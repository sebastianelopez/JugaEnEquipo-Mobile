import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

Future<List<NotificationModel>?> getNotifications({
  int limit = 20,
  int offset = 0,
}) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final String qParam = 'limit:$limit;offset:$offset';

    final response = await APIService.instance.request(
      '/api/notifications',
      DioMethod.get,
      contentType: 'application/json',
      param: {
        'q': qParam,
      },
      headers: {
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final dynamic root = response.data;
      // Most endpoints return { data: [...] }
      final dynamic listData =
          (root is Map<String, dynamic>) ? root['data'] : null;
      if (listData is List) {
        return listData
            .whereType<Map<String, dynamic>>()
            .map(_notificationFromJsonSafe)
            .toList();
      }
      // Some endpoints could return just a list
      if (root is List) {
        return root
            .whereType<Map<String, dynamic>>()
            .map(_notificationFromJsonSafe)
            .toList();
      }
      if (kDebugMode) {
        debugPrint('getNotifications: Unexpected payload shape');
      }
      return <NotificationModel>[];
    }

    if (kDebugMode) {
      debugPrint('getNotifications: status ${response.statusCode}');
    }
    return null;
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getNotifications error: $e');
    }
    return null;
  }
}

NotificationModel _notificationFromJsonSafe(Map<String, dynamic> json) {
  return NotificationModel.fromJson(json);
}

