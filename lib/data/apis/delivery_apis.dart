import '../../constants/enums.dart';
import '../../helpers/shared_preferences.dart';
import 'package:logger/logger.dart';

import 'api_settings.dart';
import '../models/common/login_model.dart';
import 'package:dio/dio.dart';

class DeliveryApis {
  final _dio = ApiSettings().dio;

  Future<dynamic> login(String phone, String password) async {
    Response response;
    try {
      var data = LoginModel(phone: phone, password: password).toJson();

      response = await _dio.post('/delivery/login', data: data);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> signUp(Map<String, dynamic> data) async {
    Response response;
    try {
      response = await _dio.post('/delivery/register', data: data);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getZonesOrders(
    int zoneId,
  ) async {
    Response response;
    try {
      response = await _dio.get('/zones/$zoneId/orders/all?', queryParameters: {
        'status': OrderType.pending.name,
      });
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getOrders(int delivId, Map<String, dynamic> querys) async {
    Response response;
    try {
      response = await _dio.get(
        '/delivery/orders?',
        queryParameters: querys,
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

// delivery /order/orderId/booking

// restaurant
  Future<dynamic> patchOrder(int orderId, Map<String, dynamic> data,
      {String? booking}) async {
    Response response;
    try {
      response = await _dio.patch('/order/$orderId' + (booking ?? ""),
          data: data,
          options: Options(headers: {
            'Authorization': "Bearer ${DeliverkSharedPreferences.getToken()}"
          }));
      return response.data;
    } on DioError catch (e) {
      Logger().d(e.response!.data);
      return e.response!.data;
    }
  }

  Future<dynamic> deleteOrder(int orderId) async {
    Response response;
    try {
      response = await _dio.delete('/order/$orderId',
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
      response = await _dio.get(
        '/delivery/$id',
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> online(bool status) async {
    try {
      Response response;
      response = await _dio.patch('/delivery/online',
          data: {'online': status},
          options: Options(headers: {
            'Authorization': "Bearer ${DeliverkSharedPreferences.getToken()}"
          }));
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
}
