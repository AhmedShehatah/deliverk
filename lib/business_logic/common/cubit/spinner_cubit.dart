// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part '../state/spinner_state.dart';

class SpinnerCubit extends Cubit<SpinnerState> {
  SpinnerCubit() : super(SpinnerInitial());
  String? payment;
  String? preparation;
  void changePaymentSate(String text) {
    emit(SpinnerInitial(paymentState: text, preparationState: preparation));
    payment = text;
    Logger().d(text);
  }

  void changePreparationState(String text) {
    emit(SpinnerInitial(preparationState: text, paymentState: payment));
    preparation = text;
  }
}
