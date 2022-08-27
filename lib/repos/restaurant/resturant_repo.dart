import 'dart:io';

import '../../data/apis/restaurant_apis.dart';
import '../../data/apis/upload_image.dart';

class RestaurantRepo {
  final _api = RestaurantApis();

  Future<dynamic> login(String phone, String password) async =>
      _api.login(phone, password);

  Future<dynamic> uploadImage(File file) async =>
      UploadImage().uploadImage(file);

  Future<dynamic> signUp(Map<String, dynamic> data) async => _api.signUp(data);

  Future<dynamic> getRestProfileData(int id) => _api.getProfileData(id);

  Future<dynamic> getOrders(Map<String, dynamic> querys, int id) =>
      _api.getOrders(querys, id);
  Future<dynamic> getOrdersAll() => _api.getOrdersAll();

  Future<dynamic> addOrder(Map<String, dynamic> data, String token) =>
      _api.addOrder(data, token);
}
