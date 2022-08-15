import 'dart:async';
import 'dart:io';

import 'package:deliverk/business_logic/common/cubit/spinner_cubit.dart';
import 'package:deliverk/zones.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../business_logic/common/cubit/upload_image_cubit.dart';
import '../../../business_logic/restaurant/cubit/restaurant_sign_up_cubit.dart';

import '../../../data/models/restaurant/restaurant_sign_up_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../../business_logic/restaurant/state/restaurant_sign_up_state.dart';
import '../../../constants/enums.dart';
import '../../../constants/strings.dart';
import '../../widgets/common/spinner.dart';
import '../../widgets/common/text_field.dart';

class ResturantSignUpScreen extends StatefulWidget {
  const ResturantSignUpScreen({Key? key}) : super(key: key);

  @override
  State<ResturantSignUpScreen> createState() => _ResturantSignUpScreenState();
}

class _ResturantSignUpScreenState extends State<ResturantSignUpScreen> {
  final TextEditingController _restName = TextEditingController();

  final TextEditingController _restPhoneNumber = TextEditingController();

  final TextEditingController _restPlaceInDetials = TextEditingController();
  final _passwordController = TextEditingController();
  File? _image;
  LatLng? _location;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildLogoImage(),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: CustomTextField(
                      controller: _restName,
                      hint: "اسم المحل",
                      inputType: TextInputType.name,
                      action: TextInputAction.next,
                    ),
                  ),
                  BlocBuilder<SpinnerCubit, SpinnerState>(
                    builder: (context, state) {
                      if (state is SpinnerZoneState) {
                        _zoneId = zones[state.zoneName];
                      }
                      return Spinner(
                        "المنطقة",
                        _zonesList,
                        SpinnerEnum.zone,
                      );
                    },
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(mapRoute).then(
                          (value) {
                            setState(() {
                              _location = value as LatLng?;
                            });
                          },
                        );
                      },
                      child: _location == null
                          ? Row(
                              children: const [
                                Text("الموقع على الخريطة"),
                                Icon(Icons.location_on)
                              ],
                            )
                          : Row(
                              children: const [
                                Text("تم اختيار الموقع بنجاح"),
                                Icon(Icons.check)
                              ],
                            ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: CustomTextField(
                      controller: _restPlaceInDetials,
                      hint: "المكان بالتفصيل",
                      inputType: TextInputType.multiline,
                      action: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 100),
                    child: Divider(
                      color: Colors.black45,
                      height: 1,
                      thickness: 1,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: CustomTextField(
                      controller: _restPhoneNumber,
                      hint: "رقم التلفون",
                      inputType: TextInputType.phone,
                      action: TextInputAction.next,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: CustomTextField(
                      controller: _passwordController,
                      hint: "الرقم السري",
                      inputType: TextInputType.text,
                      secure: true,
                    ),
                  ),
                  BlocBuilder<RestaurantSignUpCubit, RestaurantSignUpState>(
                    builder: (context, state) {
                      if (state is LoadingState) {
                        return const CircularProgressIndicator(
                          color: Colors.blue,
                        );
                      } else if (state is SuccessState) {
                        WidgetsBinding.instance
                            ?.addPostFrameCallback((timeStamp) {
                          Fluttertoast.showToast(
                              msg:
                                  'تم تسجيل الدخول بنجاح انتظر حتى يتم تفعيلك');
                          Navigator.of(context)
                              .pushReplacementNamed(restaurantLoginRoute);
                        });
                        return buildSignUpButton();
                      } else if (state is FailedState) {
                        Logger().d(state.message);
                        Fluttertoast.showToast(msg: state.message);
                        return buildSignUpButton();
                      } else {
                        return buildSignUpButton();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLogoImage() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          pickImage().then((file) {
            setState(() {
              if (file != null) {
                _image = File(file.path);
                BlocProvider.of<UploadImageCubit>(context).uploadImage(_image!);
              }
            });
          });
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          child: CircleAvatar(
            radius: 90,
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            child: FittedBox(
              fit: BoxFit.cover,
              child: _image == null
                  ? Column(
                      children: [
                        Image.asset(
                          "assets/images/camera.png",
                        ),
                        const Text("لوجو المحل")
                      ],
                    )
                  : CircleAvatar(
                      backgroundImage: Image.file(_image!).image,
                      radius: 90,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<XFile?> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      return image;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Widget buildSignUpButton() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 50, right: 50, bottom: 40),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _signUp(context);
        },
        child: const Text("تسجيل"),
      ),
    );
  }

  bool _chekcer() {
    if (_image == null ||
        _restName.text.isEmpty ||
        _restPhoneNumber.text.isEmpty ||
        _location == null ||
        _zoneId == null ||
        _restPlaceInDetials.text.isEmpty ||
        _passwordController.text.isEmpty) return false;
    return true;
  }

  void _signUp(BuildContext context) {
    var imageProvider = BlocProvider.of<UploadImageCubit>(context);
    var signUpProvider = BlocProvider.of<RestaurantSignUpCubit>(context);
    if (!_chekcer()) {
      Fluttertoast.showToast(msg: "من فضلك اكمل البيانات");
      return;
    }
    var url = imageProvider.url;
    var model = RestaurantSignUpModel();
    model.avatar = url;
    model.name = _restName.text;
    model.address = _restPlaceInDetials.text;
    model.isActive = true;
    model.mapLat = _location?.latitude.toString();
    model.mapLong = _location?.longitude.toString();
    model.password = _passwordController.text;
    model.phone = _restPhoneNumber.text;
    model.zoneId = _zoneId;

    signUpProvider.signUp(model.toJson());
  }

  @override
  void initState() {
    getZones();
    super.initState();
  }

  Map<String, int> zones = {};
  final List<String> _zonesList = [];
  int? _zoneId;
  void getZones() async {
    Zones().getZones().then((value) async {
      var box = await Hive.openBox<Map<String, int>>('zones');
      zones = box.get('zone')!;
      zones.forEach((key, value) {
        _zonesList.add(key);
      });
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
