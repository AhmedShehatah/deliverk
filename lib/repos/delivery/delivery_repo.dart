import '../../data/apis/delivery_apis.dart';

class DeliveryRepo {
  final _api = DeliveryApis();

  Future<dynamic> login(String phone, String password) async =>
      _api.login(phone, password);

  Future<dynamic> signUp(Map<String, dynamic> data) async => _api.signUp(data);

  Future<dynamic> getZoneOrders(
          int zoneId, Map<String, dynamic> querys) async =>
      _api.getZonesOrders(zoneId, querys);

  Future<dynamic> getOrders(int delivId, Map<String, dynamic> querys) async =>
      _api.getOrders(delivId, querys);
  Future<dynamic> patchOrder(int orderId, Map<String, dynamic> data) async =>
      _api.patchOrder(orderId, data);
  Future<dynamic> getProflieData(int id) async => _api.getDeliveryProfile(id);
}
