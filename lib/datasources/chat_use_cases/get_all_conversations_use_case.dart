import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/chat/conversation_model.dart';

Future<List<ConversationModel>> getAllConversations() async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    final response = await APIService.instance.request(
      '/api/conversations',
      DioMethod.get,
      contentType: 'application/json',
      headers: {
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseData = response.data;
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('data')) {
        final List<dynamic> data =
            responseData['data'] as List<dynamic>? ?? [];
        return data
            .map((e) {
              try {
                return ConversationModel.fromJson(e as Map<String, dynamic>);
              } catch (e) {
                if (kDebugMode) {
                  debugPrint('Error parsing conversation: $e');
                }
                return null;
              }
            })
            .whereType<ConversationModel>()
            .toList();
      }
      if (kDebugMode) {
        debugPrint('getAllConversations: Unexpected response format');
      }
      return [];
    }

    if (kDebugMode) {
      debugPrint('getAllConversations: status ${response.statusCode}');
    }
    return [];
  } on DioException catch (e) {
    if (kDebugMode) {
      debugPrint('getAllConversations DioException: ${e.type}');
      debugPrint('getAllConversations error message: ${e.message}');
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        debugPrint('Timeout error - request took too long');
      }
    }
    // Return empty list on timeout/network errors
    return [];
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getAllConversations unexpected error: $e');
    }
    return [];
  }
}

