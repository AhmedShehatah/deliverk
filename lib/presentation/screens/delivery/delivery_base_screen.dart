import '../../../business_logic/common/cubit/area_cubit.dart';
import '../../../business_logic/common/cubit/refresh_cubit.dart';
import '../../../business_logic/common/state/generic_state.dart';
import '../../../business_logic/delivery/cubit/delivery_all_orders_cubit.dart';
import '../../../business_logic/delivery/cubit/delivery_online_cubit.dart';
import '../../../business_logic/delivery/cubit/delivery_orders_cubit.dart';
import '../../../business_logic/delivery/cubit/delivery_profile_cubit.dart';
import '../../../business_logic/delivery/cubit/delivery_zone_orders_cubit.dart';

import '../../../helpers/shared_preferences.dart';
import '../../../repos/delivery/delivery_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    return BlocListener<DeliveryProfileCubit, GenericState>(
      listener: (context, state) {
        if (state is GenericFailureState) {
          Fluttertoast.showToast(
              msg: 'حدث خطأ ما من فضلك قم باعادة تسجيل الدخول');

          DeliverkSharedPreferences.deleteAll().then((value) {
            DeliveryBaseScreen.pop(context);
          });
        } else if (state is GenericSuccessState) {
          DeliverkSharedPreferences.setZoneId(state.data['zone_id']);
        }
      },
      child: BlocBuilder<AreaCubit, GenericState>(
        builder: (context, state) {
          if (state is GenericSuccessState) {
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
              stateManagement: false,
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
          } else if (state is GenericLoadingState) {
            return const Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                color: Colors.blue,
              )),
            );
          } else if (state is GenericFailureState) {
            return const Scaffold(
              body: Center(child: Text('حدث خطا قم باعادة تشغيل التطيبق')),
            );
          } else {
            return const Text('');
          }
        },
      ),
    );
  }

  List<Widget> _buildScreens(BuildContext context) {
    return [
      MultiBlocProvider(
        providers: [
          BlocProvider<DeliveryZoneOrdersCubit>(
            create: (context) => DeliveryZoneOrdersCubit(DeliveryRepo()),
          ),
          BlocProvider<RefreshCubit>(
            create: (context) => RefreshCubit(),
          ),
        ],
        child: const DeliveryCurrentOrdersScreen(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider<DeliveryAllOrdersCubit>(
            create: (context) => DeliveryAllOrdersCubit(DeliveryRepo()),
          ),
          BlocProvider<RefreshCubit>(create: (_) => RefreshCubit()),
        ],
        child: const DeliveryDoingOrderScreen(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider<DeliveryOrdersCubit>(
            create: (context) => DeliveryOrdersCubit(DeliveryRepo()),
          ),
          BlocProvider<RefreshCubit>(create: (_) => RefreshCubit())
        ],
        child: const DeliveryUnpaidOrdersScreen(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider<DeliveryProfileCubit>(
            create: (context) => DeliveryProfileCubit(DeliveryRepo()),
          ),
          BlocProvider<RefreshCubit>(create: (_) => RefreshCubit()),
          BlocProvider<DeliveryOnlineCubit>(
            create: (_) => DeliveryOnlineCubit(DeliveryRepo()),
          )
        ],
        child: DeliveryProfileScreen(
          context: context,
        ),
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

  @override
  void initState() {
    BlocProvider.of<AreaCubit>(context).loadAreas();
    var id = DeliverkSharedPreferences.getDelivId();
    if (id != null) {
      BlocProvider.of<DeliveryProfileCubit>(context).getProfileData(id);
    } else {
      DeliveryBaseScreen.pop(context);
    }
    super.initState();
  }
}
