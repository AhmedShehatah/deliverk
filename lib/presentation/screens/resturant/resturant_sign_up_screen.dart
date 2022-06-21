import 'dart:io';
import '../../../constants/enums.dart';
import '../../widgets/common/text_field.dart';
import '../../widgets/common/spinner.dart';

import '../../../constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ResturantSignUpScreen extends StatefulWidget {
  const ResturantSignUpScreen({Key? key}) : super(key: key);

  @override
  State<ResturantSignUpScreen> createState() => _ResturantSignUpScreenState();
}

class _ResturantSignUpScreenState extends State<ResturantSignUpScreen> {
  final TextEditingController _restName = TextEditingController();

  final TextEditingController _restPhoneNumber = TextEditingController();

  final TextEditingController _restPlaceInDetials = TextEditingController();
  File? _image;

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
                        hint: "اسم المطعم",
                        inputType: TextInputType.name),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: CustomTextField(
                      controller: _restPhoneNumber,
                      hint: "رقم التلفون",
                      inputType: TextInputType.phone,
                    ),
                  ),
                  const Spinner(
                    "المنطقة",
                    ["المنيب", "الجيزة", "رمسيس"],
                    SpinnerEnum.zone,
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: CustomTextField(
                      controller: _restPlaceInDetials,
                      hint: "المكان بالتفصيل",
                      inputType: TextInputType.multiline,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  buildSignUpButton(),
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
              if (file != null) _image = File(file.path);
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
                        const Text("لوجو المطعم")
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
          Navigator.of(context).pushReplacementNamed(restaurantBaseScreenRoute);
        },
        child: const Text("تسجيل"),
      ),
    );
  }
}
