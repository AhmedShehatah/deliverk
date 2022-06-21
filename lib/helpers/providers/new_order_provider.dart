import 'package:flutter/widgets.dart';

class NewOrderProvider with ChangeNotifier {
  String selectedState = "";
  void changeText(String text) {
    selectedState = text;
    notifyListeners();
  }
}
