import 'api_settings.dart';
import '../models/common/login_model.dart';

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

  Future<dynamic> signUp(Map<String, dynamic> data) async {
    Response response;
    try {
      response = await _dio.post('/restaurants/register', data: data);
      return response.data;
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> getProfileData(int id) async {
    Response response;
    try {
      response = await _dio.get('/restaurants/$id');
      _log.d(response.data);
      return response.data;
    } catch (e) {
      _log.d(e);
      return e;
    }
  }

  Future<dynamic> getOrders(Map<String, dynamic> querys, int id) async {
    Response response;

    try {
      response =
          await _dio.get('/restaurants/$id/orders?', queryParameters: querys);

      return response.data;
    } catch (e) {
      _log.d(e);
      return e;
    }
  }
}
