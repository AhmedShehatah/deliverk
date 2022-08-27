import 'api_settings.dart';
import 'package:dio/dio.dart';

import '../../helpers/shared_preferences.dart';

class AreaApi {
  final Dio _dio = ApiSettings().dio;

  Future<dynamic> getAreas() async {
    Response response;
    try {
      response = await _dio.get('/areas/all');

      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getRestAreas(int restId) async {
    Response response;
    try {
      response = await _dio.get(
        '/restaurant/areas',
        options: Options(
          headers: {
            'Authorization': "Bearer ${DeliverkSharedPreferences.getToken()}"
          },
        ),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
}
