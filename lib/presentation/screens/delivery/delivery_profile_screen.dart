import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/logger.dart';
import '../../../business_logic/common/state/generic_state.dart';

import '../../../business_logic/delivery/cubit/delivery_profile_cubit.dart';
import '../../../data/models/delivery/delivery_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:url_launcher/url_launcher.dart';

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
  DeliveryModel info = DeliveryModel();
  @override
  Widget build(BuildContext context) {
    Logger().d('this builds again bro');
    int? id = DeliverkSharedPreferences.getDelivId();
    if (id != null) {
      BlocProvider.of<DeliveryProfileCubit>(context).getProfileData(id);
    } else {
      DeliveryBaseScreen.pop(widget.context);
    }
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: SingleChildScrollView(
            child: BlocBuilder<DeliveryProfileCubit, GenericState>(
              builder: (context, state) {
                if (state is GenericSuccessState) {
                  info = DeliveryModel.fromJson(state.data);

                  _isActive = info.online!;
                  return Column(
                    children: [
                      _buildHeader(info.avatar!),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 80, right: 30, left: 30),
                        child: const PopupMenuDivider(),
                      ),
                      _buildMoneyInfo(
                        info.cash ?? 0,
                        info.doneTotal ?? 0,
                      ),
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
      ),
    );
  }

  Future<void> refresh() async {
    int? id = DeliverkSharedPreferences.getDelivId();
    if (id != null) {
      BlocProvider.of<DeliveryProfileCubit>(context).getProfileData(id);
    } else {
      DeliveryBaseScreen.pop(widget.context);
    }
  }

  bool? _isActive;
  Widget _buildProfileInfo(BuildContext context, String name, String phone) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     BlocBuilder<DeliveryOnlineCubit, GenericState>(
            //         builder: ((context, state) {
            //       if (state is GenericSuccessState) {
            //         _isActive = state.data;
            //       } else if (state is GenericLoadingState) {
            //         return const Padding(
            //           padding: EdgeInsets.all(8.0),
            //           child: CircularProgressIndicator(color: Colors.blue),
            //         );
            //       }
            //       return Switch(
            //         value: _isActive!,
            //         onChanged: (value) {
            //           BlocProvider.of<DeliveryOnlineCubit>(context)
            //               .online(value);
            //         },
            //       );
            //     })),
            //     const Text('نشط'),
            //   ],
            // ),
            _buildInfoTexts("الاسم", name),
            const Divider(),
            _buildInfoTexts("رقم التلفون", phone),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    logout();
                  },
                  child: const Text(
                    "تسجيل خروج",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    openwhatsapp();
                  },
                  child: const Text(
                    "تواصل معنا",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
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

  Widget _buildMoneyInfo(int cost, int total) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildData("الملبغ المستحق", cost, Colors.red),
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
                _buildData("عدد الطلبات", total, Colors.green),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  BlocProvider.of<DeliveryProfileCubit>(context)
                      .getProfileData(DeliverkSharedPreferences.getDelivId()!);
                },
                child: const Text('تحديث')),
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
      crossAxisAlignment: CrossAxisAlignment.center,
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
    DeliverkSharedPreferences.deleteAll().then((value) {
      DeliveryBaseScreen.pop(widget.context);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  openwhatsapp() async {
    var whatsapp = "+201030773677";
    var whatsappURlAndroid = "whatsapp://send?phone=" + whatsapp;
    var whatappURLIos = "https://wa.me/$whatsapp";

    if (Platform.isIOS) {
      var url = Uri.parse(whatappURLIos);
      await launchUrl(url);
      // if (await canLaunchUrl(url)) {
      // } else {
      //   // launchUrl(Uri.parse("tel://" + whatsapp));
      // }
    } else {
      var url = Uri.parse(whatsappURlAndroid);

      await launchUrl(url);
      // Logger().d(await canLaunchUrl(url));
      // if (await canLaunch(whatsappURlAndroid)) {
      // } else {
      //   // launchUrl(Uri.parse("tel://" + whatsapp));
      // }
    }
  }
}
