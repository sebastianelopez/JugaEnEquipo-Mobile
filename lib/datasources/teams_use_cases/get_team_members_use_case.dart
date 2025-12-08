import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

/// Get team members by team ID
/// 
/// Returns a list of UserModel representing the members of the team
Future<List<UserModel>?> getTeamMembers(String teamId) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null || accessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('getTeamMembers: No access token found');
      }
      return null;
    }

    final response = await APIService.instance.request(
      '/api/team/$teamId/members',
      DioMethod.get,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Manage the response
    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint('getTeamMembers: API call successful');
        debugPrint('getTeamMembers: Response data type: ${response.data.runtimeType}');
        debugPrint('getTeamMembers: Response data: ${response.data}');
      }

      // Validate response structure
      if (response.data == null) {
        if (kDebugMode) {
          debugPrint('getTeamMembers: Response data is null');
        }
        return null;
      }

      // Handle response structure: API returns { "data": [...] }
      dynamic membersData;
      
      if (response.data is Map<String, dynamic>) {
        final responseMap = response.data as Map<String, dynamic>;
        if (responseMap['data'] != null) {
          membersData = responseMap['data'];
          if (kDebugMode) {
            debugPrint('getTeamMembers: Found data field');
            if (membersData is List) {
              debugPrint('getTeamMembers: Data contains ${membersData.length} members');
            }
          }
        } else {
          if (kDebugMode) {
            debugPrint('getTeamMembers: No data field found in response');
          }
          return null;
        }
      } else if (response.data is List) {
        // Handle case where API returns list directly
        membersData = response.data;
        if (kDebugMode) {
          debugPrint('getTeamMembers: Response is a list with ${membersData.length} items');
        }
      } else {
        if (kDebugMode) {
          debugPrint('getTeamMembers: Unexpected response structure: ${response.data.runtimeType}');
        }
        return null;
      }

      if (membersData is! List) {
        if (kDebugMode) {
          debugPrint('getTeamMembers: Response data is not a list. Type: ${membersData.runtimeType}');
        }
        return null;
      }

      try {
        final members = <UserModel>[];
        
        for (var memberData in membersData) {
          try {
            if (kDebugMode) {
              debugPrint('getTeamMembers: Parsing member: $memberData');
            }
            
            if (memberData is! Map<String, dynamic>) {
              if (kDebugMode) {
                debugPrint('getTeamMembers: Member is not a Map, skipping');
              }
              continue;
            }
            
            final member = UserModel.fromJson(memberData);
            members.add(member);
            
            if (kDebugMode) {
              debugPrint('getTeamMembers: Successfully parsed member: ${member.userName}');
            }
          } catch (e) {
            if (kDebugMode) {
              debugPrint('getTeamMembers: Error parsing individual member: $e');
              debugPrint('getTeamMembers: Member data: $memberData');
            }
            // Continue parsing other members even if one fails
          }
        }
        
        if (kDebugMode) {
          debugPrint('getTeamMembers: Successfully parsed ${members.length} members out of ${membersData.length}');
        }
        
        return members;
      } catch (e, stackTrace) {
        if (kDebugMode) {
          debugPrint('getTeamMembers: Error parsing members list: $e');
          debugPrint('getTeamMembers: Stack trace: $stackTrace');
        }
        return null;
      }
    } else if (response.statusCode == 401) {
      // Unauthorized
      if (kDebugMode) {
        debugPrint('getTeamMembers: Unauthorized - invalid token');
      }
      return null;
    } else if (response.statusCode == 404) {
      // Not found
      if (kDebugMode) {
        debugPrint('getTeamMembers: Team not found');
      }
      return null;
    } else {
      // Error: Manage the error response
      if (kDebugMode) {
        debugPrint(
            'getTeamMembers: API call failed with status ${response.statusCode}: ${response.statusMessage}');
      }
      return null;
    }
  } catch (e) {
    // Error: Manage network errors
    if (kDebugMode) {
      debugPrint('getTeamMembers: Network error occurred: $e');
    }
    return null;
  }
}

