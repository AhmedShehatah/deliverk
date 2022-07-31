import 'package:deliverk/constants/strings.dart';
import 'package:deliverk/presentation/screens/common/splash_screen.dart';
import 'package:deliverk/presentation/screens/delivery/delivery_unpaid_orders_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'deliver_current_orders_screen.dart';
import 'delivery_doing_orders_screen.dart';
import 'delivery_profile_screen.dart';

class DeliveryBaseScreen extends StatelessWidget {
  DeliveryBaseScreen({Key? key}) : super(key: key);
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

  List<Widget> _buildScreens(BuildContext context) {
    return [
      const DeliveryCurrentOrdersScreen(),
      const DeliveryDoingOrderScreen(),
      const DeliveryUnpaidOrdersScreen(),
      DeliveryProfileScreen(
        context: context,
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

  static void pop(BuildContext context) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const SplashScreen(),
      ),
      (route) => false, //if you want to disable back feature set to false
    );
    // pushNewScreen(
    //   context,
    //   screen: const SplashScreen(),

    //   withNavBar: false, // OPTIONAL VALUE. True by default.
    //   pageTransitionAnimation: PageTransitionAnimation.slideRight, // OPTIONAL
    // );
  }
}
