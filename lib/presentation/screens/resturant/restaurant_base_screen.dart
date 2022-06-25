import 'unpaied_orders_screen.dart';

import '../../../constants/strings.dart';
import 'resturant_orders_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class RestaurantBaseScreen extends StatefulWidget {
  const RestaurantBaseScreen({Key? key}) : super(key: key);

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
      floatingActionButton:
          _isOrdersScreenSelected ? _buildFloatingActionButton(context) : null,
      context,
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

  List<Widget> _buildScreens() {
    return [
      RestaurantOrdersScreen(),
      const UnpaiedOrdersScreen(),
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
}
