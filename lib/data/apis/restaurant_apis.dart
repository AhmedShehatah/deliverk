import '../../constants/enums.dart';
import '../../helpers/shared_preferences.dart';
import 'package:logger/logger.dart';

import 'api_settings.dart';
import '../models/common/login_model.dart';

import 'package:dio/dio.dart';

class RestaurantApis {
  final _dio = ApiSettings().dio;

  Future<dynamic> login(String phone, String password) async {
    Response response;
    try {
      var data = LoginModel(phone: phone, password: password).toJson();
      response = await _dio.post('/restaurant/login', data: data);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> signUp(Map<String, dynamic> data) async {
    Response response;
    try {
      response = await _dio.post('/restaurant/register', data: data);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getProfileData(int id) async {
    Response response;
    try {
      response = await _dio.get(
        '/restaurant/$id',
      );

      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getOrders(Map<String, dynamic> querys, int id) async {
    Response response;

    try {
      response = await _dio.get(
        '/restaurant/orders?',
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

  Future<dynamic> getOrdersAll() async {
    Response response;

    try {
      response = await _dio.get(
        '/restaurant/orders/all?',
        queryParameters: {'status': OrderType.pending.name},
        options: Options(
          headers: {
            'Authorization': "Bearer ${DeliverkSharedPreferences.getToken()}"
          },
        ),
      );

      return response.data;
    } on DioError catch (e) {
      Logger().d(e.error);
      return e.response!.data;
    }
  }

  Future<dynamic> addOrder(Map<String, dynamic> data, String token) async {
    Response response;
    try {
      response = await _dio.post(
        '/order/',
        data: data,
        options: Options(headers: {'Authorization': "Bearer $token"}),
      );
      return response.data;
    } on DioError catch (e) {
      Logger().d(e.response!.data);
      return e.response!.data;
    }
  }
}
