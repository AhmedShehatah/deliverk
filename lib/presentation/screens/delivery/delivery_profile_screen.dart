import 'package:deliverk/constants/strings.dart';
import 'package:deliverk/helpers/shared_preferences.dart';
import 'package:deliverk/presentation/screens/common/splash_screen.dart';
import 'package:deliverk/presentation/screens/delivery/delivery_base_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryProfileScreen extends StatelessWidget {
  const DeliveryProfileScreen({Key? key, required this.context})
      : super(key: key);
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Container(
                margin: const EdgeInsets.only(top: 80, right: 30, left: 30),
                child: const PopupMenuDivider(),
              ),
              _buildMoneyInfo(),
              const SizedBox(
                height: 10,
              ),
              _buildProfileInfo(context),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoTexts("الاسم", "احمد شحاته"),
            const Divider(),
            _buildInfoTexts("رقم التلفون", "01093766715"),
            //   const Divider(),
            //   _buildInfoTexts("رقم تلفون المحل", "01093766715"),
            //   const Divider(),
            //   _buildInfoTexts("العنوان على الخريطة", "اضغط للعرض"),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red),
              onPressed: () {
                logout();
              },
              child: const Text(
                "تسجيل خروج",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTexts(String title, String value) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(title), Text(value)],
        ),
      ),
    );
  }

  Widget _buildMoneyInfo() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildData("الملبغ المستحق", 500, Colors.red),
            SizedBox(
              height: 60,
              child: VerticalDivider(
                color: Colors.grey.shade300,
                thickness: 1,
                indent: 5,
                endIndent: 0,
                width: 20,
              ),
            ),
            _buildData("عدد الطلبات", 30, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildData(String title, int value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, color: color),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          value.toString(),
          style: TextStyle(
            color: color,
          ),
        )
      ],
    );
  }

  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.blue,
        ),
        Positioned(
          top: 130,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: const AssetImage("assets/images/logo.png"),
          ),
        )
      ],
    );
  }

  void logout() {
    DeliverkSharedPreferences.deleteToken().then((value) {
      DeliveryBaseScreen.pop(context);
    });
  }
}
