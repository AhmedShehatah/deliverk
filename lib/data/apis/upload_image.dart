import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'api_settings.dart';

class UploadImage {
  final Dio _dio = ApiSettings().dio;
  final _log = Logger();

  Future<dynamic> uploadImage(File file) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    Response response;
    try {
      response = await _dio.post('/upload', data: formData);
      _log.d(response);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
}
