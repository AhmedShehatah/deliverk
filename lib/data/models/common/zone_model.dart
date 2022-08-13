import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class ZoneModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  ZoneModel({required this.id, required this.name});

  factory ZoneModel.formJson(Map<String, dynamic> json) => ZoneModel(
        id: json['id'] as int,
        name: json['name'] as String,
      );

  get areaId => null;
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
