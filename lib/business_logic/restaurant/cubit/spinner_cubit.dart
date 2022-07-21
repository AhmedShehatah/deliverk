// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'spinner_state.dart';

class SpinnerCubit extends Cubit<SpinnerState> {
  SpinnerCubit() : super(SpinnerInitial());
  String? _payment;
  String? _preparation;
  void changePaymentSate(String text) {
    emit(SpinnerInitial(paymentState: text, preparationState: _preparation));
    _payment = text;
    Logger().d(text);
  }

  void changePreparationState(String text) {
    emit(SpinnerInitial(preparationState: text, paymentState: _payment));
    _preparation = text;
  }
}
