import '../../data/apis/delivery_apis.dart';

class DeliveryRepo {
  final _api = DeliveryApis();

  Future<dynamic> login(String phone, String password) async =>
      _api.login(phone, password);
}
