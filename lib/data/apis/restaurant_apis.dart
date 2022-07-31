import 'package:deliverk/data/apis/api_settings.dart';
import 'package:deliverk/data/models/common/login_model.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class RestaurantApis {
  final _dio = ApiSettings().dio;
  final _log = Logger();
  Future<dynamic> login(String phone, String password) async {
    Response response;
    try {
      var data = LoginModel(phone: phone, password: password).toJson();
      response = await _dio.post('/restaurants/login', data: data);
      _log.d(response.data);
      return response.data;
    } catch (e) {
      _log.d(e);
      return e;
    }
  }
}
