import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jugaenequipo/datasources/api_service.dart';

Future<Result> createPost(String text, List<File>? files, String id) async {
  try {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    // Build form data
    final Map<String, dynamic> formDataMap = {
      'body': text,
    };

    // Add files as MultipartFile objects
    if (files != null && files.isNotEmpty) {
      final List<MultipartFile> multipartFiles = [];
      for (final file in files) {
        final fileName = file.path.split('/').last;
        final multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );
        multipartFiles.add(multipartFile);
      }
      formDataMap['files'] = multipartFiles;
    }

    final FormData formData = FormData.fromMap(formDataMap);

    final response = await APIService.instance.request(
      '/api/post/$id',
      DioMethod.post,
      formData: formData,
      contentType: 'multipart/form-data',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Handle the response
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success: Process the response data
      if (kDebugMode) {
        debugPrint('createPost - API call successful: ${response.data}');
      }
      return Result.success;
    } else {
      // Error: Handle the error response
      if (kDebugMode) {
        debugPrint('createPost - API call failed: ${response.statusMessage}');
      }
      return Result.error;
    }
  } catch (e) {
    // Error: Handle network errors
    if (kDebugMode) {
      debugPrint('createPost - Network error occurred: $e');
    }
    return Result.error;
  }
}
