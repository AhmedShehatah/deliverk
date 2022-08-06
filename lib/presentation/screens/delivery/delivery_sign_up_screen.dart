import 'dart:io';

import 'package:deliverk/business_logic/common/cubit/upload_image_cubit.dart';
import 'package:deliverk/business_logic/common/state/generic_state.dart';
import 'package:deliverk/business_logic/common/state/upload_image_state.dart';
import 'package:deliverk/business_logic/delivery/cubit/deliver_sign_up_cubit.dart';
import 'package:deliverk/data/models/delivery/delivery_model.dart';
import 'package:deliverk/presentation/widgets/common/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../../constants/strings.dart';
import '../../widgets/common/text_field.dart';

class DeliverySignUpScreen extends StatefulWidget {
  const DeliverySignUpScreen({Key? key}) : super(key: key);

  @override
  State<DeliverySignUpScreen> createState() => _DeliverySignUpScreenState();
}

class _DeliverySignUpScreenState extends State<DeliverySignUpScreen> {
  final _deliveryNameController = TextEditingController();
  final _deliveryPhoneNumberContoller = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _deliveryPhoto;
  File? _deliveryId;
  File? _deliveryDrivingLicene;
  File? _drivierMotorLicence;
  final Map<String, dynamic> _data = {};
  late UploadImageCubit _imageProvider;
  @override
  void initState() {
    super.initState();
    _imageProvider = BlocProvider.of<UploadImageCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildDeliveryImage(),
              const SizedBox(
                height: 10,
              ),
              buildPickIDPhoto(),
              buildPickDrividingLicencePhoto(),
              buildPickMotorLicencePhoto(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Divider(
                  color: Colors.black45,
                  height: 1,
                  thickness: 1,
                ),
              ),
              Form(key: _formKey, child: _buildFields()),
              buildSignUpButton(),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildFields() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: CustomTextField(
            controller: _deliveryNameController,
            hint: "الاسم",
            inputType: TextInputType.name,
            action: TextInputAction.next,
            validator:
                (_deliveryNameController.text.isEmpty) ? 'ادخل الاسم' : null,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: CustomTextField(
            controller: _deliveryPhoneNumberContoller,
            hint: "رقم التلفون",
            inputType: TextInputType.phone,
            action: TextInputAction.next,
            validator: (_deliveryPhoneNumberContoller.text.isEmpty)
                ? 'ادخل رقم التلفون'
                : null,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: CustomTextField(
            controller: _passwordController,
            hint: "الرقم السري",
            inputType: TextInputType.phone,
            secure: true,
            validator: (_passwordController.text.isEmpty ||
                    _passwordController.text.length < 8)
                ? 'الرقم السري 8 حروف على الاقل'
                : null,
          ),
        ),
      ],
    );
  }

  Widget buildUploadedState(String message, Color color, IconData icon) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              message,
              style: TextStyle(
                color: color,
              ),
            ),
            Icon(
              icon,
              color: color,
            )
          ],
        ),
      ),
    );
  }

  bool _isUploadedId = false;
  Widget buildPickIDPhoto() {
    return BlocBuilder<UploadImageCubit, UploadImageState>(
      builder: (context, state) {
        if (state is SuccessState) {
          _data['nat_img'] = state.imageUrl;
        } else if (state is FailedState) {
          setState(() {
            _deliveryId = null;
            Logger().d('id');
          });
          Fluttertoast.showToast(msg: 'اعد اخيار الصورة');
        }
        return Directionality(
          textDirection: TextDirection.rtl,
          child: TextButton(
            onPressed: () {
              pickImage().then((file) {
                setState(() {
                  if (file != null) {
                    _deliveryId = File(file.path);
                    _imageProvider.uploadImage(_deliveryId!);
                  }
                  _isUploadedId = true;
                });
              });
            },
            child: (!_isUploadedId && _deliveryId == null)
                ? const Text("ارفق صورة البطاقة")
                : _isUploadedId
                    ? buildUploadedState("تم ارفاق صورة البطاقة بنجاح",
                        Colors.green, Icons.check)
                    : buildUploadedState(
                        "تعذر ارفاق صورة البطاقة", Colors.red, Icons.clear),
          ),
        );
      },
    );
  }

  bool _isUploadingDrivingLicence = false;
  Widget buildPickDrividingLicencePhoto() {
    return BlocBuilder<UploadImageCubit, UploadImageState>(
      builder: (context, state) {
        if (state is SuccessState) {
          _data['delv_lic_img'] = state.imageUrl;
        } else if (state is FailedState) {
          setState(() {
            _deliveryDrivingLicene = null;
            Logger().d('driving licence');
          });
          Fluttertoast.showToast(msg: 'اعد اخيار الصورة');
        }
        return Directionality(
          textDirection: TextDirection.rtl,
          child: TextButton(
            onPressed: () {
              pickImage().then((file) {
                setState(() {
                  if (file != null) {
                    _deliveryDrivingLicene = File(file.path);
                    _imageProvider.uploadImage(_deliveryDrivingLicene!);
                  }
                  _isUploadingDrivingLicence = true;
                });
              });
            },
            child: (!_isUploadingDrivingLicence &&
                    _deliveryDrivingLicene == null)
                ? const Text("ارفق صورة رخصة القيادة")
                : _isUploadingDrivingLicence && _deliveryDrivingLicene != null
                    ? buildUploadedState("تم ارفاق صورة رخصة القيادة بنجاح",
                        Colors.green, Icons.check)
                    : buildUploadedState("تعذر ارفاق صورة رخصة القيادة",
                        Colors.red, Icons.clear),
          ),
        );
      },
    );
  }

  bool _isMotorLicenceUploaded = false;
  Widget buildPickMotorLicencePhoto() {
    return BlocBuilder<UploadImageCubit, UploadImageState>(
      builder: (context, state) {
        if (state is SuccessState) {
          _data['veh_lic_img'] = state.imageUrl;
        } else if (state is FailedState) {
          setState(() {
            _drivierMotorLicence = null;
            Logger().d('photo');
          });
          Fluttertoast.showToast(msg: 'اعد اخيار الصورة');
        }
        return SizedBox(
          width: double.infinity,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: TextButton(
              onPressed: () {
                pickImage().then((file) {
                  setState(() {
                    if (file != null) {
                      _drivierMotorLicence = File(file.path);
                      _imageProvider.uploadImage(_drivierMotorLicence!);
                    }
                    _isMotorLicenceUploaded = true;
                  });
                });
              },
              child: (!_isMotorLicenceUploaded && _drivierMotorLicence == null)
                  ? const Text("ارفق صورة رخصة الموتوسيكل")
                  : _isMotorLicenceUploaded && _drivierMotorLicence != null
                      ? buildUploadedState(
                          "تم ارفاق صورة رخصة الموتوسيكل بنجاح",
                          Colors.green,
                          Icons.check)
                      : buildUploadedState("تعذر ارفاق صورة رخصة الموتوسيكل",
                          Colors.red, Icons.clear),
            ),
          ),
        );
      },
    );
  }

  Future<XFile?> pickImage() async {
    try {
      XFile? image =
          (await ImagePicker().pickImage(source: ImageSource.gallery));
      return image;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Widget buildDeliveryImage() {
    return BlocBuilder<UploadImageCubit, UploadImageState>(
      builder: (context, state) {
        if (state is SuccessState) {
          _data['avatar'] = state.imageUrl;
        } else if (state is FailedState) {
          setState(() {
            _deliveryPhoto = null;
            Logger().d('photo');
          });
          Fluttertoast.showToast(msg: 'اعد اخيار الصورة');
        }
        return Container(
          margin: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () {
              pickImage().then((file) {
                setState(() {
                  if (file == null) return;
                  _deliveryPhoto = File(file.path);
                  _imageProvider.uploadImage(_deliveryPhoto!);
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
                  child: _deliveryPhoto == null
                      ? Column(
                          children: [
                            Image.asset(
                              "assets/images/camera.png",
                            ),
                            const Text("صورة شخصية")
                          ],
                        )
                      : CircleAvatar(
                          backgroundImage: Image.file(_deliveryPhoto!).image,
                          radius: 90,
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildSignUpButton() {
    return BlocBuilder<DeliverySignUpCubit, GenericState>(
      builder: (context, state) {
        if (state is GenericSuccessState) {
          Fluttertoast.showToast(msg: 'انتظر حتى يتم تفعيل حسابك');
          Navigator.of(context).popAndPushNamed(deliveryLoginRoute);
        } else if (state is LoadingState) {
          showDialog(
              context: context, builder: (context) => const LoadingDialog());
        }
        return Container(
          margin:
              const EdgeInsets.only(top: 10, left: 50, right: 50, bottom: 40),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              var log = Logger();
              log.d(_data['avatar']);
              log.d(_data['nat_img']);
              log.d(_data['delv_lic_img']);
              log.d(_data['veh_lic_img']);
              log.d(_formKey.currentState);
              log.d(_formKey.currentState!.validate());
              if (_data['avatar'] != null &&
                  _data['nat_img'] != null &&
                  _data['delv_lic_img'] != null &&
                  _data['veh_lic_img'] != null) {
                _data['name'] = _deliveryNameController.text;
                _data['phone'] = _deliveryPhoneNumberContoller.text;
                _data['password'] = _passwordController.text;
                _data['zone_id'] = 1;
                _data['online'] = false;
                Logger().d(_data);

                BlocProvider.of<DeliverySignUpCubit>(context)
                    .signUp(DeliveryModel.fromJson(_data).toJson());
              } else {
                Fluttertoast.showToast(msg: 'ادخل كامل البيانات والصور صحيحة');
              }
            },
            child: const Text("تسجيل"),
          ),
        );
      },
    );
  }
}
