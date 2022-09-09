import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:deliverk/constants/strings.dart';
import '../../../business_logic/common/state/generic_state.dart';

import '../../../data/models/restaurant/restaurant_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../business_logic/restaurant/cubit/restaurant_profile_cubit.dart';
import 'restaurant_base_screen.dart';
import 'package:flutter/material.dart';

import '../../../helpers/shared_preferences.dart';

class RestaurantProfileScreen extends StatefulWidget {
  const RestaurantProfileScreen({Key? key, required this.context})
      : super(key: key);
  final BuildContext context;

  @override
  State<RestaurantProfileScreen> createState() =>
      _RestaurantProfileScreenState();
}

class _RestaurantProfileScreenState extends State<RestaurantProfileScreen> {
  RestaurantModel _profileData = RestaurantModel();
  @override
  Widget build(BuildContext context) {
    int? id = DeliverkSharedPreferences.getRestId();
    Logger().d('build from proifle');
    if (id != null) {
      BlocProvider.of<ResturantProfileCubit>(context).getProfileData(id);
    } else {
      RestaurantBaseScreen.pop(widget.context);
    }

    return Scaffold(
        body: RefreshIndicator(
      onRefresh: refresh,
      child: BlocBuilder<ResturantProfileCubit, GenericState>(
        builder: (context, state) {
          if (state is GenericSuccessState) {
            _profileData = RestaurantModel.fromJson(state.data);
            return _buildTree();
          }
          return _buildDownladingData();
        },
      ),
    ));
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

  Widget _buildTree() {
    return SafeArea(
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
            _buildProfileInfo(),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoTexts("اسم المحل", _profileData.name!),
            const Divider(),
            FittedBox(
              fit: BoxFit.cover,
              child: _buildInfoTexts(
                "عنوان المحل",
                _profileData.address!,
              ),
            ),
            const Divider(),
            _buildInfoTexts("رقم تلفون المحل", _profileData.phone!),
            const Divider(),
            InkWell(
                onTap: () {
                  RestaurantBaseScreen.showMap(
                      widget.context,
                      LatLng(double.parse(_profileData.mapLat!),
                          double.parse(_profileData.mapLong!)));
                },
                child: _buildInfoTexts("العنوان على الخريطة", "اضغط للعرض")),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(widget.context).pushNamed(editProfile, arguments: {
                  'url': _profileData.avatar,
                  'location': LatLng(
                    double.parse(_profileData.mapLat!),
                    double.parse(_profileData.mapLong!),
                  ),
                });
              },
              icon: const Icon(Icons.edit),
              label: const Text('تعديل الملف'),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            FittedBox(
              fit: BoxFit.contain,
              child: Text(title),
            ),
            const Spacer(),
            Expanded(
              child: SizedBox(
                child: Text(
                  value,
                  textAlign: TextAlign.left,
                  softWrap: true,
                  maxLines: 10,
                ),
              ),
            )
          ],
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
            _buildData("الملبغ المستحق", _profileData.cash!, Colors.red),
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
            _buildData(
                "عدد الطلبات", _profileData.doneTotal ?? 0, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildData(String title, int value, Color color) {
    return Column(
      children: [
        FittedBox(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: color),
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        FittedBox(
          fit: BoxFit.cover,
          child: Text(
            value.toString(),
            overflow: TextOverflow.fade,
            style: TextStyle(
              color: color,
            ),
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
          child: CachedNetworkImage(
            imageUrl: _profileData.avatar!,
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
        ),
      ],
    );
  }

  void logout() {
    DeliverkSharedPreferences.deleteAll().then((value) {
      RestaurantBaseScreen.pop(widget.context);
    });
  }

  Future<void> refresh() async {
    int? id = DeliverkSharedPreferences.getRestId();

    if (id != null) {
      BlocProvider.of<ResturantProfileCubit>(context).getProfileData(id);
    } else {
      RestaurantBaseScreen.pop(widget.context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  openwhatsapp() async {
    var whatsapp = "+201030773677";
    var whatsappURlAndroid = "whatsapp://send?phone=" + whatsapp + "&text=";
    var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse("")}";

    if (Platform.isIOS) {
      var url = Uri.parse(whatappURLIos);
      await launchUrl(url);
      // if (await canLaunchUrl(url)) {
      // } else {
      //   launchUrl(Uri.parse("tel://" + whatsapp));
      // }
    } else {
      var url = Uri.parse(whatsappURlAndroid);
      await launchUrl(url);
      // if (await canLaunchUrl(url)) {
      // } else {
      //   launchUrl(Uri.parse("tel://" + whatsapp));
      // }
    }
  }
}
