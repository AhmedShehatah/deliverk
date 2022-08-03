class RestaurantSignUpModel {
  String? address;
  String? avatar;
  String? password;
  String? mapLat;
  String? mapLong;
  String? name;
  String? phone;
  int? zoneId;
  bool? isActive;

  RestaurantSignUpModel({
    this.address,
    this.avatar,
    this.password,
    this.mapLat,
    this.mapLong,
    this.name,
    this.phone,
    this.zoneId,
    this.isActive,
  });

  factory RestaurantSignUpModel.fromJson(Map<String, dynamic> json) {
    return RestaurantSignUpModel(
      address: json['address'] as String?,
      avatar: json['avatar'] as String?,
      password: json['password'] as String?,
      mapLat: json['map_lat'] as String?,
      mapLong: json['map_long'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      zoneId: json['zone_id'] as int?,
      isActive: json['is_active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'address': address,
        'avatar': avatar,
        'password': password,
        'map_lat': mapLat,
        'map_long': mapLong,
        'name': name,
        'phone': phone,
        'zone_id': zoneId,
        'is_active': isActive,
      };
}
