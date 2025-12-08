import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jugaenequipo/datasources/refresh_token_interceptor.dart';

enum DioMethod { post, get, put, delete, patch }

enum Result { success, unauthorized, error }

class APIService {
  static final APIService instance = APIService._singleton();
  late final Dio _dio;
  APIService._singleton() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        validateStatus: (status) => status! < 500,
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: true,
        request: true,
      ));
    }

    _dio.interceptors.add(RefreshTokenInterceptor(_dio));
  }

  String get baseUrl => 'https://api.jugaenequipo.com';

  Future<Response> request(
    String endpoint,
    DioMethod method, {
    Map<String, dynamic>? param,
    String? contentType,
    dynamic formData,
    Map<String, String>? headers,
    ResponseType? responseType,
  }) async {
    try {
      debugPrint('Starting request to: $baseUrl$endpoint');

      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        throw DioException(
          requestOptions: RequestOptions(path: endpoint),
          error: 'No internet connection',
        );
      }

      _dio.options.headers = headers;
      if (contentType == 'application/json') {
        _dio.options.contentType = Headers.jsonContentType;
      } else {
        _dio.options.contentType =
            contentType ?? Headers.formUrlEncodedContentType;
      }

      final Response response;
      switch (method) {
        case DioMethod.get:
          response = await _dio.get(
            endpoint,
            queryParameters: param,
            options: Options(
              followRedirects: true,
              validateStatus: (status) => status! < 500,
              responseType: responseType,
            ),
          );
          break;
        case DioMethod.post:
          response = await _dio.post(
            endpoint,
            data: param ?? formData,
            options: Options(responseType: responseType),
          );
          break;
        case DioMethod.put:
          response = await _dio.put(
            endpoint,
            data: param ?? formData,
            options: Options(responseType: responseType),
          );
          break;
        case DioMethod.patch:
          response = await _dio.patch(
            endpoint,
            data: param ?? formData,
            options: Options(responseType: responseType),
          );
          break;
        case DioMethod.delete:
          response = await _dio.delete(
            endpoint,
            data: param ?? formData,
            options: Options(responseType: responseType),
          );
          break;
        default:
          throw Exception('Invalid method');
      }

      debugPrint('Response received: ${response.statusCode}');
      return response;
    } on DioException catch (e) {
      debugPrint('Dio error: ${e.type}');
      debugPrint('Error message: ${e.message}');
      debugPrint('Error response: ${e.response}');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      rethrow;
    }
  }
}
