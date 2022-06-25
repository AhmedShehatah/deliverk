import 'package:flutter/widgets.dart';

class NewOrderProvider with ChangeNotifier {
  String paymentState = "";
  void changePaymentSate(String text) {
    paymentState = text;
    notifyListeners();
  }

  String preparationState = "";
  void changePreparationState(String text) {
    preparationState = text;
    notifyListeners();
  }
}
