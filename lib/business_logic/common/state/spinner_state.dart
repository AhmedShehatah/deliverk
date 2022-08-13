part of '../cubit/spinner_cubit.dart';

@immutable
abstract class SpinnerState {}

class SpinnerInitial extends SpinnerState {
  final String? paymentState;
  final String? preparationState;
  SpinnerInitial({this.paymentState, this.preparationState});
}

class SpinnerZoneState extends SpinnerState {
  final String zoneName;
  SpinnerZoneState(this.zoneName);
}
