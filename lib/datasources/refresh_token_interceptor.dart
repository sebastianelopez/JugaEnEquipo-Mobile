import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as flutter_storage;
import 'package:jugaenequipo/datasources/api_service.dart';

class RefreshTokenInterceptor extends Interceptor {
  final storage = const flutter_storage.FlutterSecureStorage();
  final Dio dio;
  List<Map<dynamic, dynamic>> failedRequests = [];
  bool isRefreshing = false;

  final VoidCallback onRefreshToken;

  RefreshTokenInterceptor(this.dio, this.onRefreshToken);

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refresh_token');
  }

  Future<void> refreshToken() async {
    final refreshToken = await getRefreshToken();

    if (refreshToken == null || isRefreshing) {
      // No refresh token or already refreshing, handle error
      if (kDebugMode) {
        debugPrint('No refresh token or already refreshing');
      }
      return;
    }

    isRefreshing = true;

    try {
      final response = await APIService.instance.request(
        '/api/refresh-token', // enter the endpoint for required API call
        DioMethod.post,
        param: {
          'refreshToken': refreshToken,
        },
        contentType: 'application/json',
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['token'];
        if (kDebugMode) {
          debugPrint('token refreshed successfully');
        }
        await storage.write(key: 'access_token', value: newAccessToken);
      } else {
        // Refresh token failed, handle error (e.g., logout)
        if (kDebugMode) {
          debugPrint('Refresh token failed');
        }
        await storage.deleteAll();
        throw Exception('Refresh token failed');
      }
    } catch (e) {
      // Handle refresh token failure (e.g., logout)
      if (kDebugMode) {
        debugPrint('Refresh token failed: $e');
      }
    } finally {
      isRefreshing = false;
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final oldRefreshToken = await getRefreshToken();

    if (oldRefreshToken != null) {
      if (kDebugMode) {
        debugPrint(err.response?.statusCode.toString());
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

            onRefreshToken();
          }
        } catch (e) {
          // TODO:: Handle refresh token failure (e.g., logout)
          if (kDebugMode) {
            debugPrint('Refresh token failed: $e');
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
      // Handle other errors
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
          'Authorization': 'Bearer $token', // Set the new token here
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
