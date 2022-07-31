import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LoginModel {
  String? phone;
  String? password;

  LoginModel({this.phone, this.password});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        phone: json['phone'] as String?,
        password: json['password'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'password': password,
      };
}
