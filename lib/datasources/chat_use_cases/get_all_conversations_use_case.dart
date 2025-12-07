import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/chat/conversation_model.dart';
import 'package:jugaenequipo/datasources/models/chat/conversations_response_model.dart';

Future<ConversationsResponseModel> getAllConversations() async {
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
      if (kDebugMode) {
        debugPrint(
            'getAllConversations response status: ${response.statusCode}');
        debugPrint(
            'getAllConversations response data type: ${responseData.runtimeType}');
        debugPrint('getAllConversations response data: $responseData');
      }

      List<dynamic>? dataList;
      Map<String, dynamic>? metadataMap;

      // Try to extract data from different possible response structures
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data')) {
          final dataValue = responseData['data'];
          if (dataValue is List) {
            dataList = dataValue;
          } else if (dataValue is Map && dataValue.containsKey('data')) {
            // Nested data structure
            dataList = dataValue['data'] as List<dynamic>?;
          }
        } else if (responseData.containsKey('conversations')) {
          // Alternative structure with 'conversations' key
          dataList = responseData['conversations'] as List<dynamic>?;
        } else if (responseData.values.isNotEmpty &&
            responseData.values.first is List) {
          // Data might be directly in the map
          dataList = responseData.values.first as List<dynamic>?;
        }

        // Extract metadata
        if (responseData.containsKey('metadata')) {
          final metadataValue = responseData['metadata'];
          if (metadataValue is Map<String, dynamic>) {
            metadataMap = metadataValue;
          }
        }
      } else if (responseData is List) {
        // Response is directly a list
        dataList = responseData;
      }

      if (dataList != null) {
        if (kDebugMode) {
          debugPrint(
              'getAllConversations: Found ${dataList.length} conversations in data array');
        }

        final conversations = dataList
            .map((e) {
              try {
                if (e is Map<String, dynamic>) {
                  if (kDebugMode) {
                    debugPrint('Parsing conversation: $e');
                  }
                  return ConversationModel.fromJson(e);
                } else {
                  if (kDebugMode) {
                    debugPrint(
                        'Conversation item is not a Map: ${e.runtimeType}');
                  }
                  return null;
                }
              } catch (e, stackTrace) {
                if (kDebugMode) {
                  debugPrint('Error parsing conversation: $e');
                  debugPrint('Stack trace: $stackTrace');
                }
                return null;
              }
            })
            .whereType<ConversationModel>()
            .toList();

        if (kDebugMode) {
          debugPrint(
              'getAllConversations: Successfully parsed ${conversations.length} conversations');
        }

        // Extract metadata
        final metadata = metadataMap != null
            ? ConversationsMetadata.fromJson(metadataMap)
            : ConversationsMetadata(
                total: conversations.length, totalUnreadMessages: 0);

        return ConversationsResponseModel(
          conversations: conversations,
          metadata: metadata,
        );
      }

      if (kDebugMode) {
        debugPrint(
            'getAllConversations: Could not extract data list from response');
        debugPrint('Response data type: ${responseData.runtimeType}');
        if (responseData is Map) {
          debugPrint(
              'Response data keys: ${(responseData as Map).keys.toList()}');
        }
      }
      return ConversationsResponseModel(
        conversations: [],
        metadata: ConversationsMetadata(total: 0, totalUnreadMessages: 0),
      );
    }

    if (kDebugMode) {
      debugPrint('getAllConversations: status ${response.statusCode}');
    }
    return ConversationsResponseModel(
      conversations: [],
      metadata: ConversationsMetadata(total: 0, totalUnreadMessages: 0),
    );
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
    return ConversationsResponseModel(
      conversations: [],
      metadata: ConversationsMetadata(total: 0, totalUnreadMessages: 0),
    );
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getAllConversations unexpected error: $e');
    }
    return ConversationsResponseModel(
      conversations: [],
      metadata: ConversationsMetadata(total: 0, totalUnreadMessages: 0),
    );
  }
}
