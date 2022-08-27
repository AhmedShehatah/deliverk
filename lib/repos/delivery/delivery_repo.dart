import '../../data/apis/delivery_apis.dart';

class DeliveryRepo {
  final _api = DeliveryApis();

  Future<dynamic> login(String phone, String password) async =>
      _api.login(phone, password);

  Future<dynamic> signUp(Map<String, dynamic> data) async => _api.signUp(data);

  Future<dynamic> getZoneOrders(int zoneId) async =>
      _api.getZonesOrders(zoneId);

  Future<dynamic> getOrders(int delivId, Map<String, dynamic> querys) async =>
      _api.getOrders(delivId, querys);
  Future<dynamic> patchOrder(int orderId, Map<String, dynamic> data,
          {String? booking}) async =>
      _api.patchOrder(orderId, data, booking: booking);

  Future<dynamic> deleteOrder(int orderId) async => _api.deleteOrder(orderId);
  Future<dynamic> getProflieData(int id) async => _api.getDeliveryProfile(id);

  Future<dynamic> online(bool status) async => _api.online(status);
}
