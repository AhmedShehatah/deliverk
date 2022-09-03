class DeliveryModel {
  String? name;
  String? phone;
  String? password;
  String? avatar;
  String? natImg;
  String? delvLicImg;
  String? vehLicImg;
  int? cash;
  bool? online;
  int? zoneId;
  int? delivId;
  int? doneTotal;

  DeliveryModel(
      {this.name,
      this.phone,
      this.password,
      this.avatar,
      this.natImg,
      this.delvLicImg,
      this.vehLicImg,
      this.cash,
      this.online,
      this.zoneId,
      this.delivId,
      this.doneTotal});

  factory DeliveryModel.fromJson(Map<String, dynamic> json) => DeliveryModel(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String?,
      avatar: json['avatar'] as String?,
      natImg: json['nat_img'] as String?,
      delvLicImg: json['delv_lic_img'] as String?,
      vehLicImg: json['veh_lic_img'] as String?,
      cash: json['cash'] as dynamic,
      online: json['online'] as bool?,
      zoneId: json['zone_id'] as int?,
      delivId: json['deliv_id'] as int?,
      doneTotal: json['done_total'] as int?);

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'password': password,
        'avatar': avatar,
        'nat_img': natImg,
        'delv_lic_img': delvLicImg,
        'veh_lic_img': vehLicImg,
        'cash': cash,
        'online': online,
        'zone_id': zoneId,
        'deliv_id': delivId,
        'done_total': doneTotal,
      };
}
