import 'package:dio/dio.dart';

import '../../constants/strings.dart';

class ApiSettings {
  late Dio dio;
  ApiSettings() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000, // 60 seconds,
      receiveTimeout: 20 * 1000,
    );
    dio = Dio(options);
  }
}
