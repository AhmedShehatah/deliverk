import 'api_settings.dart';
import '../models/common/login_model.dart';

import 'package:dio/dio.dart';

class RestaurantApis {
  final _dio = ApiSettings().dio;

  Future<dynamic> login(String phone, String password) async {
    Response response;
    try {
      var data = LoginModel(phone: phone, password: password).toJson();
      response = await _dio.post('/restaurants/login', data: data);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> signUp(Map<String, dynamic> data) async {
    Response response;
    try {
      response = await _dio.post('/restaurants/register', data: data);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getProfileData(int id) async {
    Response response;
    try {
      response = await _dio.get('/restaurants/$id');

      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getOrders(Map<String, dynamic> querys, int id) async {
    Response response;

    try {
      response =
          await _dio.get('/restaurants/$id/orders?', queryParameters: querys);

      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> addOrder(Map<String, dynamic> data, String token) async {
    Response response;
    try {
      _dio.options.headers['authorization'] = "Bearer $token";
      response = await _dio.post(
        '/orders',
        data: data,
        options: Options(headers: {'Authorization': "Bearer $token"}),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
}
