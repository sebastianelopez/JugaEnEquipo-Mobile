import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as flutter_storage;
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/main.dart';

class RefreshTokenInterceptor extends Interceptor {
  final storage = const flutter_storage.FlutterSecureStorage();
  final Dio dio;
  List<Map<dynamic, dynamic>> failedRequests = [];
  bool isRefreshing = false;

  RefreshTokenInterceptor(this.dio);

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refresh_token');
  }

  Future<void> refreshToken() async {
    final refreshToken = await getRefreshToken();

    if (refreshToken == null || isRefreshing) {
      if (kDebugMode) {
        debugPrint('No refresh token or already refreshing');
      }
      return;
    }

    isRefreshing = true;

    try {
      final accessToken = await storage.read(key: 'access_token');
      if (kDebugMode) {
        debugPrint('token refresh: $accessToken');
        debugPrint('refresh tokennnnn: $refreshToken');
      }

      final response = await APIService.instance.request(
        '/api/refresh-token',
        DioMethod.post,
        param: {
          'refreshToken': refreshToken,
        },
        contentType: 'application/json',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['token'];
        final newRefreshToken = response.data['refreshToken'];
        if (kDebugMode) {
          debugPrint('token refreshed successfully');
        }
        await storage.write(key: 'access_token', value: newAccessToken);
        await storage.write(key: 'refresh_token', value: newRefreshToken);
        navigatorKey.currentState?.pushReplacementNamed('home');
      } else {
        if (kDebugMode) {
          debugPrint('Refresh token failed');
        }
        await storage.deleteAll();
        navigatorKey.currentState?.pushReplacementNamed('login');
        throw Exception('Refresh token failed');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Refresh token failed: $e');
        await storage.deleteAll();
        navigatorKey.currentState?.pushReplacementNamed('login');
      }
    } finally {
      isRefreshing = false;
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final oldRefreshToken = await getRefreshToken();

    if (err.response?.statusCode == 401 && oldRefreshToken != null) {
      if (kDebugMode) {
        debugPrint('Interceptor onError: ${err.response?.statusCode}');
      }
      if (failedRequests.isEmpty) {
        try {
          await refreshToken();
          final newToken = await storage.read(key: 'access_token');
          if (newToken != null) {
            failedRequests.add({
              'url': err.requestOptions.uri.toString(),
              'method': err.requestOptions.method,
              'headers': err.requestOptions.headers,
              'data': err.requestOptions.data,
            });
            await retryRequests(newToken, handler);
            failedRequests.clear();
          }
        } catch (e) {
          // TODO:: Handle refresh token failure (e.g., logout)
          if (kDebugMode) {
            debugPrint('Interceptor onError: Refresh token failed: $e');
          }
        }
      } else {
        failedRequests.add({
          'url': err.requestOptions.uri.toString(),
          'method': err.requestOptions.method,
          'headers': err.requestOptions.headers,
          'data': err.requestOptions.data,
        });
      }
    } else {
      handler.next(err);
    }
  }

  Future<void> retryRequests(
      String token, ErrorInterceptorHandler handler) async {
    for (final request in failedRequests) {
      final options = Options(
        method: request['method'],
        headers: {
          ...request['headers'],
          'Authorization': 'Bearer $token',
        },
      );

      try {
        final response = await dio.request(
          request['url'],
          options: options,
          data: request['data'],
        );

        handler.resolve(response);
      } catch (e) {
        handler.reject(DioException(
          requestOptions: request['requestOptions'],
          error: e,
        ));
      }
    }
  }
}
