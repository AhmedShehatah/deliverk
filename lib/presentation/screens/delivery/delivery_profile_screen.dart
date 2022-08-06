import 'package:cached_network_image/cached_network_image.dart';
import 'package:deliverk/business_logic/common/state/generic_state.dart';
import 'package:deliverk/business_logic/delivery/cubit/delivery_profile_cubit.dart';
import 'package:deliverk/data/models/delivery/delivery_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helpers/shared_preferences.dart';
import 'delivery_base_screen.dart';
import 'package:flutter/material.dart';

class DeliveryProfileScreen extends StatefulWidget {
  const DeliveryProfileScreen({Key? key, required this.context})
      : super(key: key);
  final BuildContext context;

  @override
  State<DeliveryProfileScreen> createState() => _DeliveryProfileScreenState();
}

class _DeliveryProfileScreenState extends State<DeliveryProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocBuilder<DeliveryProfileCubit, GenericState>(
            builder: (context, state) {
              if (state is GenericSuccessState) {
                var info = DeliveryModel.fromJson(state.data);
                return Column(
                  children: [
                    _buildHeader(info.avatar!),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 80, right: 30, left: 30),
                      child: const PopupMenuDivider(),
                    ),
                    _buildMoneyInfo(),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildProfileInfo(context, info.name!, info.phone!),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                );
              }
              return _buildDownladingData();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, String name, String phone) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoTexts("الاسم", name),
            const Divider(),
            _buildInfoTexts("رقم التلفون", phone),
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

  Widget _buildHeader(String url) {
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
          child: CachedNetworkImage(
            imageUrl: url,
            imageBuilder: (context, imageProvider) => Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircleAvatar(
              radius: 70,
              backgroundColor: Colors.grey.shade600,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        )
      ],
    );
  }

  Widget _buildDownladingData() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: Image.asset(
            'assets/images/loading.gif',
          ),
        ),
        const Text("انتظر قليلا")
      ],
    ));
  }

  void logout() {
    DeliverkSharedPreferences.deleteToken().then((value) {
      DeliveryBaseScreen.pop(widget.context);
    });
  }

  @override
  void initState() {
    int? id = DeliverkSharedPreferences.getDelivId();
    BlocProvider.of<DeliveryProfileCubit>(context).getProfileData(id ?? 1);
    super.initState();
  }
}
