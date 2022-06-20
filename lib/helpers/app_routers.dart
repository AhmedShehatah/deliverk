import '../presentation/screens/resturant/restaurant_base_screen.dart';
import '../presentation/screens/resturant/restaurant_new_order.dart';

import '../presentation/screens/delivery/delivery_sign_up_screen.dart';
import 'package:flutter/material.dart';

import '../constants/strings.dart';
import '../presentation/screens/common/splash_screen.dart';
import '../presentation/screens/resturant/resturant_sign_up_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // base
      case "/":
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      // returant routes
      case resturantSignUpRoute:
        return MaterialPageRoute(builder: (_) => const ResturantSignUpScreen());
      case restaurantBaseScreenRoute:
        return MaterialPageRoute(builder: (_) => const RestaurantBaseScreen());
      case restuarntNewOrderScreenRoute:
        return MaterialPageRoute(builder: (_) => RestaurantNewOrder());

      // delivery reoute
      case delivarySignUpRoute:
        return MaterialPageRoute(builder: (_) => const DeliverySignUpScreen());
    }
    return null;
  }
}
