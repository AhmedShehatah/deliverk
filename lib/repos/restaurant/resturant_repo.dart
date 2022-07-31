import 'package:deliverk/data/apis/restaurant_apis.dart';

class RestaurantRepo {
  final _api = RestaurantApis();

  Future<dynamic> login(String phone, String password) async {
    return _api.login(phone, password);
  }
}
