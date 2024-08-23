import 'dart:io';

import 'package:dio/dio.dart';

enum DioMethod { post, get, put, delete }

class APIService {
  APIService._singleton();
  static final APIService instance = APIService._singleton();

  String get baseUrl {
    return 'https://api.jugaenequipo.com';
  }

  Future<Response> request(
    String endpoint,
    DioMethod method, {
    Map<String, dynamic>? param,
    String? contentType,
    formData,
  }) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        contentType: contentType ?? Headers.formUrlEncodedContentType,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token', // if needed
        },
      ),
    );

    switch (method) {
      case DioMethod.post:
        return dio.post(
          endpoint,
          data: param ?? formData,
        );
      case DioMethod.get:
        return dio.get(
          endpoint,
          queryParameters: param,
        );
      case DioMethod.put:
        return dio.put(
          endpoint,
          data: param ?? formData,
        );
      case DioMethod.delete:
        return dio.delete(
          endpoint,
          data: param ?? formData,
        );
      default:
        return dio.post(
          endpoint,
          data: param ?? formData,
        );
    }
  }
}
