import 'package:deliverk/business_logic/restaurant/cubit/spinner_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/screens/common/map_screen.dart';

import '../presentation/screens/delivery/delivery_base_screen.dart';
import 'package:flutter/material.dart';

import '../constants/strings.dart';
import '../presentation/screens/common/splash_screen.dart';
import '../presentation/screens/delivery/delivery_sign_up_screen.dart';
import '../presentation/screens/resturant/restaurant_base_screen.dart';
import '../presentation/screens/resturant/restaurant_new_order.dart';
import '../presentation/screens/resturant/resturant_sign_up_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // base
      case "/":
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      // map
      case mapRoute:
        return MaterialPageRoute(builder: (_) => const MapScreen());

      // returant routes
      case resturantSignUpRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<SpinnerCubit>(
            create: (context) => SpinnerCubit(),
            child: const ResturantSignUpScreen(),
          ),
        );
      case restaurantBaseScreenRoute:
        return MaterialPageRoute(builder: (_) => const RestaurantBaseScreen());
      case restuarntNewOrderScreenRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<SpinnerCubit>(
                create: (context) => SpinnerCubit(),
                child: RestaurantNewOrder()));

      // delivery reoute
      case delivarySignUpRoute:
        return MaterialPageRoute(builder: (_) => const DeliverySignUpScreen());
      case deliveryBaseScreen:
        return MaterialPageRoute(builder: (_) => DeliveryBaseScreen());
    }
    return null;
  }
}
