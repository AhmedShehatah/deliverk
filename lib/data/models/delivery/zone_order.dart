class ZoneOrder {
  int? areaCost;
  int? areaId;
  int? cost;
  String? createdAt;
  int? delvCash;
  dynamic delvId;
  int? duration;
  dynamic fnTime;
  int? id;
  bool? isPaid;
  String? notes;
  int? resId;
  String? resLogo;
  String? status;
  int? zoneId;

  ZoneOrder({
    this.areaCost,
    this.areaId,
    this.cost,
    this.createdAt,
    this.delvId,
    this.duration,
    this.fnTime,
    this.delvCash,
    this.id,
    this.isPaid,
    this.notes,
    this.resId,
    this.resLogo,
    this.status,
    this.zoneId,
  });

  factory ZoneOrder.fromJson(Map<String, dynamic> json) => ZoneOrder(
        areaCost: json['area_cost'] as int?,
        areaId: json['area_id'] as int?,
        cost: json['cost'] as int?,
        createdAt: json['created_at'] as String?,
        delvCash: json['delv_cash'] as int?,
        delvId: json['delv_id'] as dynamic,
        duration: json['duration'] as int?,
        fnTime: json['fn_time'] as dynamic,
        id: json['id'] as int?,
        isPaid: json['isPaid'] as bool?,
        notes: json['notes'] as String?,
        resId: json['res_id'] as int?,
        resLogo: json['res_logo'] as String?,
        status: json['status'] as String?,
        zoneId: json['zone_id'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'area_cost': areaCost,
        'area_id': areaId,
        'cost': cost,
        'created_at': createdAt,
        'delv_cash': delvCash,
        'delv_id': delvId,
        'duration': duration,
        'fn_time': fnTime,
        'id': id,
        'isPaid': isPaid,
        'notes': notes,
        'res_id': resId,
        'res_logo': resLogo,
        'status': status,
        'zone_id': zoneId,
      };
}
