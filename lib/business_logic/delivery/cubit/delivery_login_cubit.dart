import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../repos/delivery/delivery_repo.dart';
import '../state/delivery_login_state.dart';

class DeliveryLoginCubit extends Cubit<DeliveryLoginState> {
  DeliveryLoginCubit(this.repo) : super(DeliveryLoginInitial());
  final DeliveryRepo repo;
  void login(String phone, String password) {
    emit(LoadingState());
    repo.login(phone, password).then((response) {
      if (response is DioError) {
        emit(ErrorState());
        return;
      }
      if (response['success']) {
        emit(SuccessState(response['token'], response['delv_id']));
      } else {
        emit(FailedState(response['message']));
      }
    });
  }
}
