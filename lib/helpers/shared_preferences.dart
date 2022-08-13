import 'package:shared_preferences/shared_preferences.dart';

class DeliverkSharedPreferences {
  static late SharedPreferences _preferences;
  static const String _token = "token";
  static const String _userType = "user";
  static const String _resId = "restId";
  static const String _delivId = "delivId";
  static const String _zoneId = "zoneId";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setToken(String token) async =>
      await _preferences.setString(_token, token);

  static String? getToken() => _preferences.getString(_token);

  static Future deleteToken() => _preferences.remove(_token);
  static Future deleteRestId() => _preferences.remove(_resId);
  static Future deleteAll() => _preferences.clear();

  static Future setUserType(String userType) async =>
      _preferences.setString(_userType, userType);

  static String? getUserType() => _preferences.getString(_userType);

  static Future setZoneId(int zoneId) async =>
      _preferences.setInt(_zoneId, zoneId);
  static int? getZoneId() => _preferences.getInt(_zoneId);

  static Future setRestId(int restId) async =>
      _preferences.setInt(_resId, restId);
  static int? getRestId() => _preferences.getInt(_resId);

  static Future setDeliveryId(int delivId) async =>
      _preferences.setInt(_delivId, delivId);
  static int? getDelivId() => _preferences.getInt(_delivId);
}
