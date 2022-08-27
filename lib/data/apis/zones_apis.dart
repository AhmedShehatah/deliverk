import 'api_settings.dart';
import 'package:dio/dio.dart';

class ZoneApi {
  final _dio = ApiSettings().dio;
  Future<dynamic> getZones() async {
    Response response;
    try {
      response = await _dio.get('/zones');
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
}
