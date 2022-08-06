import 'package:hive/hive.dart';
part 'area_model.g.dart';

@HiveType(typeId: 1)
class AreaModel extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  AreaModel({this.id, this.name});

  factory AreaModel.formJson(Map<String, dynamic> json) =>
      AreaModel(id: json['id'] as int?, name: json['name'] as String?);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
