import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RefreshTokenInterceptor extends dio.Interceptor {
  final storage = const FlutterSecureStorage();
  final _dio = dio.Dio();
  List<Map<dynamic, dynamic>> failedRequests = [];
  bool isRefreshing = false;

  RefreshTokenInterceptor();

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refresh_token');
  }

  Future<void> refreshToken() async {
    final refreshToken = await getRefreshToken();

    if (refreshToken == null || isRefreshing) {
      // No refresh token or already refreshing, handle error
      return;
    }

    isRefreshing = true;

    try {
      final response = await _dio.post(
        '/api/refresh-token',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['token'];
        await storage.write(key: 'access_token', value: newAccessToken);
      } else {
        // Refresh token failed, handle error (e.g., logout)
        await storage.deleteAll();
        throw Exception('Refresh token failed');
      }
    } catch (e) {
      // Handle refresh token failure (e.g., logout)
      print('Refresh token failed: $e');
    } finally {
      isRefreshing = false;
    }
  }

  @override
  void onError(dio.DioError err, dio.ErrorInterceptorHandler handler) async {
    final oldRefreshToken = await getRefreshToken();

    if (err.response?.statusCode == 401 && oldRefreshToken != null) {
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
          print('Refresh token failed: $e');
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
      String token, dio.ErrorInterceptorHandler handler) async {
    for (final request in failedRequests) {
      final options = dio.Options(
        method: request['method'],
        headers: {
          ...request['headers'],
          'Authorization': 'Bearer $token', // Set the new token here
        },
      );

      try {
        final response = await _dio.request(
          request['url'],
          options: options,
          data: request['data'],
        );

        handler.resolve(response);
      } catch (e) {
        handler.reject(dio.DioError(
          requestOptions: request['requestOptions'],
          error: e,
        ));
      }
    }
  }
}
