import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class OrderModel {
  int? areaCost;
  int? areaId;
  dynamic cost;
  String? createdAt;
  dynamic delvId;
  int? duration;
  dynamic fnTime;
  int? id;
  bool? isPaid;
  String? notes;
  int? resId;
  String? status;
  int? zoneId;

  OrderModel({
    this.areaCost,
    this.areaId,
    this.cost,
    this.createdAt,
    this.delvId,
    this.duration,
    this.fnTime,
    this.id,
    this.isPaid,
    this.notes,
    this.resId,
    this.status,
    this.zoneId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        areaCost: json['area_cost'] as int?,
        areaId: json['area_id'] as int?,
        cost: json['cost'] as dynamic,
        createdAt: json['created_at'] as String?,
        delvId: json['delv_id'] as dynamic,
        duration: json['duration'] as int?,
        fnTime: json['fn_time'] as dynamic,
        id: json['id'] as int?,
        isPaid: json['isPaid'] as bool?,
        notes: json['notes'] as String?,
        resId: json['res_id'] as int?,
        status: json['status'] as String?,
        zoneId: json['zone_id'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'area_cost': areaCost,
        'area_id': areaId,
        'cost': cost,
        'created_at': createdAt,
        'delv_id': delvId,
        'duration': duration,
        'fn_time': fnTime,
        'id': id,
        'isPaid': isPaid,
        'notes': notes,
        'res_id': resId,
        'status': status,
        'zone_id': zoneId,
      };
}
