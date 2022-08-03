import 'api_settings.dart';
import '../models/common/login_model.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DeliveryApis {
  final _dio = ApiSettings().dio;
  final _log = Logger();
  Future<dynamic> login(String phone, String password) async {
    Response response;
    try {
      var data = LoginModel(phone: phone, password: password).toJson();

      response = await _dio.post('/deliveries/login', data: data);
      return response.data;
    } catch (e) {
      _log.d(e);
      return e;
    }
  }
}
