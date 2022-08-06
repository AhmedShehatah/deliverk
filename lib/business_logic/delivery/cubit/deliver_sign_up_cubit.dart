import 'package:bloc/bloc.dart';
import 'package:deliverk/business_logic/common/state/generic_state.dart';
import 'package:deliverk/repos/delivery/delivery_repo.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DeliverySignUpCubit extends Cubit<GenericState> {
  DeliverySignUpCubit(this.repo) : super(GenericStateInit());
  final DeliveryRepo repo;
  final _log = Logger();
  void signUp(Map<String, dynamic> data) {
    repo.signUp(data).then((response) {
      if (response is DioError) {
        _log.d(response.message);
        emit(GenericErrorState());

        return;
      }
      if (response['success']) {
        emit(GenericSuccessState(response['data']));
      } else {
        emit(GenericFailureState(response['message']));
      }
    });
  }
}
