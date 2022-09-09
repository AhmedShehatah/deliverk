import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:deliverk/business_logic/common/state/generic_state.dart';
import 'package:deliverk/business_logic/restaurant/cubit/restaurant_profile_cubit.dart';
import 'package:deliverk/helpers/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../../constants/strings.dart';
import '../../../data/apis/upload_image.dart';

class EditProifile extends StatefulWidget {
  const EditProifile({Key? key}) : super(key: key);

  @override
  State<EditProifile> createState() => _EditProifileState();
}

class _EditProifileState extends State<EditProifile> {
  final Map<String, dynamic> _data = {};
  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var pd = ProgressDialog(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('قم بتغيير فقط ما تريد تغييره'),
                buildLogoImage(args['url']!),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(mapRoute).then(
                        (value) {
                          setState(() {
                            _location = value as LatLng?;
                            _data['map_lat'] = _location!.latitude.toString();
                            _data['map_long'] = _location!.longitude.toString();
                          });
                        },
                      );
                    },
                    child: _location == null
                        ? Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("تغيير الموقع على الخريطة"),
                              Icon(Icons.location_on)
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("تم تغيير الموقع بنجاح"),
                              Icon(Icons.check)
                            ],
                          ),
                  ),
                ),
                BlocListener<ResturantProfileCubit, GenericState>(
                  listener: (context, state) {
                    if (state is GenericSuccessState) {
                      pd.hide();
                      Navigator.of(context).pop(true);
                    } else if (state is GenericFailureState) {
                      pd.hide();
                      Fluttertoast.showToast(msg: state.data);
                      Navigator.of(context).pop();
                    }
                  },
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      pd.show();
                      if (_image != null) {
                        await imageTemp(_image!, 'avatar');
                      }
                      BlocProvider.of<ResturantProfileCubit>(context)
                          .patchProfile(
                              DeliverkSharedPreferences.getRestId()!, _data);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('حفظ التغييرات'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  File? _image;
  LatLng? _location;

  Widget buildLogoImage(String url) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          pickImage().then((file) {
            setState(() {
              if (file != null) {
                _image = File(file.path);
              }
            });
          });
        },
        child: _image == null
            ? CircleAvatar(
                radius: 80,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    width: 160,
                    height: 160,
                  ),
                ),
              )
            : CircleAvatar(
                radius: 80,
                child: ClipOval(
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    width: 160,
                    height: 160,
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

  Future<void> imageTemp(File image, String path) async {
    await UploadImage().uploadImage(image).then((response) {
      if (response['success']) {
        _data[path] = response['url'] as String;
      } else {
        Fluttertoast.showToast(msg: 'فشل تحميل الصور');
      }
    });
  }
}
