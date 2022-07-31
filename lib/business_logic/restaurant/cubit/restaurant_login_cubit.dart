import 'package:bloc/bloc.dart';
import 'package:deliverk/repos/restaurant/resturant_repo.dart';
import 'package:dio/dio.dart';
import '../state/restaurant_login_state.dart';

class RestaurantLoginCubit extends Cubit<RestaurantLoginState> {
  RestaurantLoginCubit(this.repo) : super(RestaurantLoginInitial());
  final RestaurantRepo repo;
  void login(String phone, String password) {
    emit(LoadingState());
    repo.login(phone, password).then((response) {
      if (response is DioError) {
        emit(ErrorState());
        return;
      }
      if (response['success']) {
        emit(SuccessState(response['token']));
      } else {
        emit(FailedState(response['message']));
      }
    });
  }
}
