import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../data/models/restaurant/restaurant_model.dart';
import '../../../repos/restaurant/resturant_repo.dart';
import '../state/restaurant_sign_up_state.dart';

class RestaurantSignUpCubit extends Cubit<RestaurantSignUpState> {
  RestaurantSignUpCubit(this.repo) : super(RestaurantSignUpInitial());
  final RestaurantRepo repo;
  void signUp(Map<String, dynamic> data) {
    emit(LoadingState());
    repo.signUp(data).then((response) {
      if (response is DioError) {
        emit(ErrorState());
        return;
      }
      if (response['success']) {
        var model = RestaurantModel.fromJson(response['data']);
        emit(SuccessState(model));
      } else {
        emit(FailedState(response['message']));
      }
    });
  }
}
