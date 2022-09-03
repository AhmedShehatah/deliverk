import 'package:hive/hive.dart';

part 'restaurant_model.g.dart';

@HiveType(typeId: 0)
class RestaurantModel extends HiveObject {
  @HiveField(0)
  String? address;
  @HiveField(1)
  String? avatar;
  @HiveField(2)
  int? cash;
  @HiveField(3)
  String? createdAt;
  @HiveField(4)
  dynamic dailyCost;
  @HiveField(5)
  int? id;
  @HiveField(6)
  bool? isActive;
  @HiveField(7)
  String? mapLat;
  @HiveField(8)
  String? mapLong;
  @HiveField(9)
  String? name;
  @HiveField(10)
  String? phone;
  @HiveField(11)
  int? zoneId;
  @HiveField(12)
  int? doneTotal;

  RestaurantModel({
    this.address,
    this.avatar,
    this.cash,
    this.createdAt,
    this.dailyCost,
    this.id,
    this.isActive,
    this.mapLat,
    this.mapLong,
    this.name,
    this.phone,
    this.zoneId,
    this.doneTotal,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      address: json['address'] as String?,
      avatar: json['avatar'] as String?,
      cash: json['cash'] as int?,
      createdAt: json['created_at'] as String?,
      dailyCost: json['daily_cost'] as dynamic,
      id: json['id'] as int?,
      isActive: json['is_active'] as bool?,
      mapLat: json['map_lat'] as String?,
      mapLong: json['map_long'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      zoneId: json['zone_id'] as int?,
      doneTotal: json['done_total'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'address': address,
        'avatar': avatar,
        'cash': cash,
        'created_at': createdAt,
        'daily_cost': dailyCost,
        'id': id,
        'is_active': isActive,
        'map_lat': mapLat,
        'map_long': mapLong,
        'name': name,
        'phone': phone,
        'zone_id': zoneId,
        'done_total': doneTotal,
      };
}
