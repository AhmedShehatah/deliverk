part of 'spinner_cubit.dart';

@immutable
abstract class SpinnerState {}

class SpinnerInitial extends SpinnerState {
  final String? paymentState;
  final String? preparationState;
  SpinnerInitial({this.paymentState, this.preparationState});
}
