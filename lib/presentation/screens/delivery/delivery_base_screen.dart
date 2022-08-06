import 'package:deliverk/business_logic/delivery/cubit/delivery_orders_cubit.dart';
import 'package:deliverk/business_logic/delivery/cubit/delivery_profile_cubit.dart';
import 'package:deliverk/business_logic/delivery/cubit/delivery_zone_orders_cubit.dart';
import 'package:deliverk/repos/delivery/delivery_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/splash_screen.dart';
import 'delivery_unpaid_orders_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'deliver_current_orders_screen.dart';
import 'delivery_doing_orders_screen.dart';
import 'delivery_profile_screen.dart';

class DeliveryBaseScreen extends StatefulWidget {
  const DeliveryBaseScreen({Key? key}) : super(key: key);
  @override
  State<DeliveryBaseScreen> createState() => _DeliveryBaseScreenState();

  static void pop(BuildContext context) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const SplashScreen(),
      ),
      (route) => false, //if you want to disable back feature set to false
    );
  }
}

class _DeliveryBaseScreenState extends State<DeliveryBaseScreen> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(context),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      onItemSelected: (idx) {},
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
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

  final _currentScreen = BlocProvider<DeliveryZoneOrdersCubit>(
    create: (context) => DeliveryZoneOrdersCubit(DeliveryRepo()),
    child: const DeliveryCurrentOrdersScreen(),
  );

  final _doingScreen = BlocProvider<DeliveryOrdersCubit>(
    create: (context) => DeliveryOrdersCubit(DeliveryRepo()),
    child: const DeliveryDoingOrderScreen(),
  );

  final _unpaid = BlocProvider<DeliveryOrdersCubit>(
    create: (context) => DeliveryOrdersCubit(DeliveryRepo()),
    child: const DeliveryUnpaidOrdersScreen(),
  );

  late BlocProvider<DeliveryProfileCubit> _profileScreen;

  List<Widget> _buildScreens(BuildContext context) {
    return [
      _currentScreen,
      _doingScreen,
      _unpaid,
      _profileScreen,
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
        icon: const Icon(Icons.motorcycle),
        title: ("جاري التسليم"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.layers),
        title: ("طلبات غير مدفوعة"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.profile_circled),
        title: ("الملف الشخصي"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  void initState() {
    _profileScreen = BlocProvider<DeliveryProfileCubit>(
      create: (context) => DeliveryProfileCubit(DeliveryRepo()),
      child: DeliveryProfileScreen(
        context: context,
      ),
    );
    super.initState();
  }
}
