import 'package:deliverk/data/models/restaurant/restaurant_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<RestaurantModel> getRestData() =>
      Hive.box<RestaurantModel>('restaurant');
}
