abstract class DeliveryLoginState {}

class DeliveryLoginInitial extends DeliveryLoginState {}

class LoadingState extends DeliveryLoginState {}

class SuccessState extends DeliveryLoginState {
  final String token;
  final int delivId;
  final int zoneId;
  SuccessState(this.token, this.delivId, this.zoneId);
}

class FailedState extends DeliveryLoginState {
  final String message;
  FailedState(this.message);
}

class ErrorState extends DeliveryLoginState {}
