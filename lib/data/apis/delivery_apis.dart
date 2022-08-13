import 'package:deliverk/helpers/shared_preferences.dart';

import 'api_settings.dart';
import '../models/common/login_model.dart';
import 'package:dio/dio.dart';

class DeliveryApis {
  final _dio = ApiSettings().dio;

  Future<dynamic> login(String phone, String password) async {
    Response response;
    try {
      var data = LoginModel(phone: phone, password: password).toJson();

      response = await _dio.post('/deliveries/login', data: data);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> signUp(Map<String, dynamic> data) async {
    Response response;
    try {
      response = await _dio.post('/deliveries/register', data: data);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getZonesOrders(
      int zoneId, Map<String, dynamic> querys) async {
    Response response;
    try {
      response =
          await _dio.get('/zones/$zoneId/orders?', queryParameters: querys);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getOrders(int delivId, Map<String, dynamic> querys) async {
    Response response;
    try {
      response = await _dio.get(
        '/deliveries/$delivId/orders?',
        queryParameters: querys,
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> patchOrder(int orderId, Map<String, dynamic> data) async {
    Response response;
    try {
      response = await _dio.patch('/orders/$orderId',
          data: data,
          options: Options(headers: {
            'Authorization': "Bearer ${DeliverkSharedPreferences.getToken()}"
          }));
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> deleteOrder(int orderId) async {
    Response response;
    try {
      response = await _dio.delete('/orders/$orderId',
          options: Options(headers: {
            'Authorization': "Bearer ${DeliverkSharedPreferences.getToken()}"
          }));
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getDeliveryProfile(int id) async {
    Response response;
    try {
      response = await _dio.get('/deliveries/$id');
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
}
