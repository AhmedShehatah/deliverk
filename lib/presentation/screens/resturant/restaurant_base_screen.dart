import 'package:deliverk/business_logic/restaurant/cubit/restaurants_current_orders_cubit.dart';
import 'package:deliverk/repos/restaurant/resturant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/restaurant/cubit/restaurant_profile_cubit.dart';
import 'restaurant_record_screen.dart';

import '../common/splash_screen.dart';
import 'restaurtant_profile_screen.dart';
import 'unpaied_orders_screen.dart';

import '../../../constants/strings.dart';
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

  @override
  State<RestaurantBaseScreen> createState() => _RestaurantBaseScreenState();
}

class _RestaurantBaseScreenState extends State<RestaurantBaseScreen> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  bool _isOrdersScreenSelected = true;
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      floatingActionButton:
          _isOrdersScreenSelected ? _buildFloatingActionButton(context) : null,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      onItemSelected: (idx) {
        setState(() {
          _isOrdersScreenSelected = idx == 0;
        });
      },
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: false,
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
  }

  late RestaurantProfileScreen _profileScreen;
  final _orderScreen = BlocProvider<RestaurantCurrentOrdersCubit>(
    create: (context) => RestaurantCurrentOrdersCubit(RestaurantRepo()),
    child: const RestaurantOrdersScreen(),
  );
  final _unpaid = BlocProvider<RestaurantCurrentOrdersCubit>(
    create: (context) => RestaurantCurrentOrdersCubit(RestaurantRepo()),
    child: UnpaiedOrdersScreen(),
  );
  final _recordScreen = BlocProvider<RestaurantCurrentOrdersCubit>(
    create: (context) => RestaurantCurrentOrdersCubit(RestaurantRepo()),
    child: const RestaurantRecordScreen(),
  );
  List<Widget> _buildScreens() {
    return [
      _orderScreen,
      _unpaid,
      _recordScreen,
      BlocProvider<ResturantProfileCubit>(
        create: (context) => ResturantProfileCubit(RestaurantRepo()),
        child: _profileScreen,
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

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).pushNamed(restuarntNewOrderScreenRoute);
      },
      label: const Text("اضف طلب جديد"),
      icon: const Icon(Icons.restaurant_menu),
    );
  }

  @override
  void initState() {
    super.initState();
    _profileScreen = RestaurantProfileScreen(context: context);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
