import '../../../data/models/restaurant/restaurant_model.dart';

abstract class RestaurantSignUpState {}

class RestaurantSignUpInitial extends RestaurantSignUpState {}

class LoadingState extends RestaurantSignUpState {}

class SuccessState extends RestaurantSignUpState {
  RestaurantModel restaurantModel;
  SuccessState(this.restaurantModel);
}

class FailedState extends RestaurantSignUpState {
  final String message;
  FailedState(this.message);
}

class ErrorState extends RestaurantSignUpState {}
