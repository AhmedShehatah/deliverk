abstract class RestaurantLoginState {}

class RestaurantLoginInitial extends RestaurantLoginState {}

class LoadingState extends RestaurantLoginState {}

class SuccessState extends RestaurantLoginState {
  final String token;
  final int id;
  final int zoneId;
  SuccessState(this.token, this.id, this.zoneId);
}

class FailedState extends RestaurantLoginState {
  final String message;
  FailedState(this.message);
}

class ErrorState extends RestaurantLoginState {}
