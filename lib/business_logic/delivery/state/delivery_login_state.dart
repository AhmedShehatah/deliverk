abstract class DeliveryLoginState {}

class DeliveryLoginInitial extends DeliveryLoginState {}

class LoadingState extends DeliveryLoginState {}

class SuccessState extends DeliveryLoginState {
  final String token;
  SuccessState(this.token);
}

class FailedState extends DeliveryLoginState {
  final String message;
  FailedState(this.message);
}

class ErrorState extends DeliveryLoginState {}
