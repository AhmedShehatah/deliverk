import 'package:deliverk/business_logic/delivery/cubit/deliver_sign_up_cubit.dart';
import 'package:deliverk/business_logic/restaurant/cubit/new_order_cubit.dart';
import 'package:deliverk/presentation/screens/common/map_show_screen.dart';

import '../business_logic/common/cubit/spinner_cubit.dart';
import '../business_logic/common/cubit/upload_image_cubit.dart';
import '../business_logic/delivery/cubit/delivery_login_cubit.dart';
import '../business_logic/restaurant/cubit/restaurant_login_cubit.dart';
import '../business_logic/restaurant/cubit/restaurant_profile_cubit.dart';
import '../business_logic/restaurant/cubit/restaurant_sign_up_cubit.dart';
import '../constants/enums.dart';
import 'shared_preferences.dart';
import '../presentation/screens/delivery/delivery_login_screen.dart';
import '../presentation/screens/resturant/restaurant_login_screen.dart';
import '../repos/delivery/delivery_repo.dart';
import '../repos/restaurant/resturant_repo.dart';
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
  final RestaurantRepo _restaurantRepo = RestaurantRepo();
  final DeliveryRepo _deliveryRepo = DeliveryRepo();

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // base
      case "/":
        if (DeliverkSharedPreferences.getToken() == null) {
          return MaterialPageRoute(builder: (_) => const SplashScreen());
        } else {
          if (DeliverkSharedPreferences.getUserType() ==
              UserType.restaurant.name) {
            return MaterialPageRoute(
                builder: (_) => const RestaurantBaseScreen());
          } else {
            return MaterialPageRoute(
                builder: (_) => const DeliveryBaseScreen());
          }
        }

      case splashRouter:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      // map
      case mapRoute:
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case mapShowScreen:
        return MaterialPageRoute(
            builder: (_) => const MapShowScreen(), settings: settings);

      // returant routes
      case resturantSignUpRoute:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<SpinnerCubit>(
                create: (context) => SpinnerCubit(),
              ),
              BlocProvider<UploadImageCubit>(
                create: (context) => UploadImageCubit(_restaurantRepo),
              ),
              BlocProvider<RestaurantSignUpCubit>(
                  create: (context) => RestaurantSignUpCubit(_restaurantRepo))
            ],
            child: const ResturantSignUpScreen(),
          ),
        );
      case restaurantBaseScreenRoute:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<ResturantProfileCubit>(
                      create: (context) =>
                          ResturantProfileCubit(_restaurantRepo),
                    ),
                  ],
                  child: const RestaurantBaseScreen(),
                ));
      case restaurantLoginRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<RestaurantLoginCubit>(
                  create: (context) => RestaurantLoginCubit(_restaurantRepo),
                  child: RestaurantLoginScreen(),
                ));
      case restuarntNewOrderScreenRoute:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<SpinnerCubit>(
                create: (context) => SpinnerCubit(),
              ),
              BlocProvider<NewOrderCubit>(
                create: (context) => NewOrderCubit(_restaurantRepo),
              ),
            ],
            child: const RestaurantNewOrder(),
          ),
        );

      // delivery reoute
      case delivarySignUpRoute:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<UploadImageCubit>(
                      create: (context) => UploadImageCubit(_restaurantRepo),
                    ),
                    BlocProvider<DeliverySignUpCubit>(
                      create: (context) => DeliverySignUpCubit(_deliveryRepo),
                    ),
                  ],
                  child: const DeliverySignUpScreen(),
                ));
      case deliveryBaseScreen:
        return MaterialPageRoute(builder: (_) => const DeliveryBaseScreen());
      case deliveryLoginRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<DeliveryLoginCubit>(
                  create: (context) => DeliveryLoginCubit(_deliveryRepo),
                  child: DeliveryLoginScreen(),
                ));
    }
    return null;
  }
}
