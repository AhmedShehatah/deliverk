import 'package:hive/hive.dart';

import '../data/models/restaurant/restaurant_model.dart';

class Boxes {
  static Box<RestaurantModel> getRestData() =>
      Hive.box<RestaurantModel>('restaurant');
}
