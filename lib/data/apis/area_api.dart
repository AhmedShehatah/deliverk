import 'package:deliverk/data/apis/api_settings.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class AreaApi {
  final Dio _dio = ApiSettings().dio;
  final Logger _log = Logger();

  Future<dynamic> getAreas() async {
    Response response;
    try {
      response = await _dio.get('/areas/all');
      _log.d(response.data);
      return response.data;
    } catch (e) {
      _log.d(e);
      return e;
    }
  }
}
