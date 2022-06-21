import 'dart:io';

import '../../widgets/common/text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DeliverySignUpScreen extends StatefulWidget {
  const DeliverySignUpScreen({Key? key}) : super(key: key);

  @override
  State<DeliverySignUpScreen> createState() => _DeliverySignUpScreenState();
}

class _DeliverySignUpScreenState extends State<DeliverySignUpScreen> {
  final _deliveryNameController = TextEditingController();
  final _deliveryPhoneNumberContoller = TextEditingController();

  File? _deliveryPhoto;
  File? _deliveryId;
  File? _deliveryDrivingLicene;
  File? _drivierMotorLicence;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildDeliveryImage(),
            CustomTextField(
                controller: _deliveryNameController,
                hint: "الاسم",
                inputType: TextInputType.name),
            CustomTextField(
                controller: _deliveryPhoneNumberContoller,
                hint: "رقم التلفون",
                inputType: TextInputType.phone),
            buildPickIDPhoto(),
            buildPickDrividingLicencePhoto(),
            buildPickMotorLicencePhoto(),
            buildSignUpButton(),
          ],
        ),
      ),
    ));
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextButton(
        onPressed: () {
          pickImage().then((file) {
            setState(() {
              if (file != null) {
                _deliveryId = File(file.path);
              }
              _isUploadedId = true;
            });
          });
        },
        child: (!_isUploadedId && _deliveryId == null)
            ? const Text("ارفق صورة البطاقة")
            : _isUploadedId
                ? buildUploadedState(
                    "تم ارفاق صورة البطاقة بنجاح", Colors.green, Icons.check)
                : buildUploadedState(
                    "تعذر ارفاق صورة البطاقة", Colors.red, Icons.clear),
      ),
    );
  }

  bool _isUploadingDrivingLicence = false;
  Widget buildPickDrividingLicencePhoto() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextButton(
        onPressed: () {
          pickImage().then((file) {
            setState(() {
              if (file != null) {
                _deliveryDrivingLicene = File(file.path);
              }
              _isUploadingDrivingLicence = true;
            });
          });
        },
        child: (!_isUploadingDrivingLicence && _deliveryDrivingLicene == null)
            ? const Text("ارفق صورة رخصة القيادة")
            : _isUploadingDrivingLicence && _deliveryDrivingLicene != null
                ? buildUploadedState("تم ارفاق صورة رخصة القيادة بنجاح",
                    Colors.green, Icons.check)
                : buildUploadedState(
                    "تعذر ارفاق صورة رخصة القيادة", Colors.red, Icons.clear),
      ),
    );
  }

  bool _isMotorLicenceUploaded = false;
  Widget buildPickMotorLicencePhoto() {
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
                }
                _isMotorLicenceUploaded = true;
              });
            });
          },
          child: (!_isMotorLicenceUploaded && _drivierMotorLicence == null)
              ? const Text("ارفق صورة رخصة الموتوسيكل")
              : _isMotorLicenceUploaded && _drivierMotorLicence != null
                  ? buildUploadedState("تم ارفاق صورة رخصة الموتوسيكل بنجاح",
                      Colors.green, Icons.check)
                  : buildUploadedState("تعذر ارفاق صورة رخصة الموتوسيكل",
                      Colors.red, Icons.clear),
        ),
      ),
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
    return Container(
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          pickImage().then((file) {
            setState(() {
              if (file == null) return;
              _deliveryPhoto = File(file.path);
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
  }

  Widget buildSignUpButton() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 50, right: 50, bottom: 40),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        child: const Text("تسجيل"),
      ),
    );
  }
}
