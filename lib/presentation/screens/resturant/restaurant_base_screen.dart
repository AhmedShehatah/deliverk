import '../../../areas.dart';
import '../../../business_logic/common/cubit/area_cubit.dart';
import '../../../business_logic/common/cubit/refresh_cubit.dart';
import '../../../business_logic/common/state/generic_state.dart';
import '../../../business_logic/restaurant/cubit/all_orders_cubit.dart';
import '../../../business_logic/restaurant/cubit/restaurants_current_orders_cubit.dart';
import '../../../helpers/firebase_notification_handler.dart';
import '../common/map_show_screen.dart';

import '../../../repos/restaurant/resturant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../business_logic/restaurant/cubit/restaurant_profile_cubit.dart';
import '../../../helpers/shared_preferences.dart';
import 'restaurant_record_screen.dart';

import '../common/splash_screen.dart';
import 'restaurtant_profile_screen.dart';
import 'unpaied_orders_screen.dart';

import 'resturant_orders_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class RestaurantBaseScreen extends StatefulWidget {
  const RestaurantBaseScreen({Key? key}) : super(key: key);
  static void pop(BuildContext context) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const SplashScreen(),
      ),

      (route) => false, //if you want to disable back feature set to false
    );
  }

  static void showMap(BuildContext context, LatLng latLng) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => MapShowScreen(
          latLng: latLng,
        ),
      ),

      (route) => true, //if you want to disable back feature set to false
    );
  }

  @override
  State<RestaurantBaseScreen> createState() => _RestaurantBaseScreenState();
}

class _RestaurantBaseScreenState extends State<RestaurantBaseScreen> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResturantProfileCubit, GenericState>(
      listener: (context, state) {
        if (state is GenericFailureState) {
          Fluttertoast.showToast(
              msg: 'حدث خطأ ما من فضلك قم باعادة تسجيل الدخول');

          DeliverkSharedPreferences.deleteAll().then((value) {
            RestaurantBaseScreen.pop(context);
          });
        }
      },
      child: BlocBuilder<AreaCubit, GenericState>(
        builder: (context, state) {
          if (state is GenericSuccessState) {
            return PersistentTabView(
              context,
              controller: _controller,
              screens: _buildScreens(),
              items: _navBarsItems(),
              confineInSafeArea: true,
              backgroundColor: Colors.white,
              handleAndroidBackButtonPress: true,
              resizeToAvoidBottomInset: true,
              stateManagement: false,
              hideNavigationBarWhenKeyboardShows: true,
              decoration: NavBarDecoration(
                borderRadius: BorderRadius.circular(10.0),
                colorBehindNavBar: Colors.white,
              ),
              onItemSelected: (index) {
                setState(() {});
              },
              itemAnimationProperties: const ItemAnimationProperties(
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: const ScreenTransitionAnimation(
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle.style1,
            );
          } else if (state is GenericLoadingState) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: Text('حدث خطا ما من فضلك قم باعادة تشغيل التطبيق'),
              ),
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      MultiBlocProvider(
        providers: [
          BlocProvider<AllOrdersCubit>(
            create: (context) => AllOrdersCubit(RestaurantRepo()),
          ),
          BlocProvider<ResturantProfileCubit>(
            create: (context) => ResturantProfileCubit(RestaurantRepo()),
          ),
          BlocProvider<RefreshCubit>(create: (_) => RefreshCubit())
        ],
        child: const RestaurantOrdersScreen(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider<RestaurantCurrentOrdersCubit>(
            create: (context) => RestaurantCurrentOrdersCubit(RestaurantRepo()),
          ),
          BlocProvider<RefreshCubit>(create: (_) => RefreshCubit())
        ],
        child: UnpaiedOrdersScreen(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider<RestaurantCurrentOrdersCubit>(
            create: (context) => RestaurantCurrentOrdersCubit(RestaurantRepo()),
          ),
          BlocProvider<RefreshCubit>(create: (_) => RefreshCubit())
        ],
        child: const RestaurantRecordScreen(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider<ResturantProfileCubit>(
            create: (context) => ResturantProfileCubit(RestaurantRepo()),
          ),
          BlocProvider<RefreshCubit>(create: (_) => RefreshCubit())
        ],
        child: RestaurantProfileScreen(context: context),
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("الطلبات الحالية"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.layers),
        title: ("طلبات غير مدفوعة"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.list_bullet),
        title: ("سجل الطلبات"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.profile_circled),
        title: ("بروفايل المحل"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  FirebaseNotifications firebaseNotifications = FirebaseNotifications();
  @override
  void initState() {
    var id = DeliverkSharedPreferences.getRestId();
    firebaseNotifications.setUp(context);

    if (id != null) {
      Areas().getRestAreas();
      BlocProvider.of<AreaCubit>(context).loadAreas();
      BlocProvider.of<ResturantProfileCubit>(context).getProfileData(id);
    } else {
      RestaurantBaseScreen.pop(context);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
