abstract class RestaurantLoginState {}

class RestaurantLoginInitial extends RestaurantLoginState {}

class LoadingState extends RestaurantLoginState {}

class SuccessState extends RestaurantLoginState {
  final String token;
  SuccessState(this.token);
}

class FailedState extends RestaurantLoginState {
  final String message;
  FailedState(this.message);
}

class ErrorState extends RestaurantLoginState {}
