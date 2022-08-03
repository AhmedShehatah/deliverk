import 'package:bloc/bloc.dart';
import 'package:deliverk/business_logic/restaurant/state/generic_state.dart';
import 'package:logger/logger.dart';
import '../../../repos/restaurant/resturant_repo.dart';
import 'package:dio/dio.dart';

class ResturantProfileCubit extends Cubit<GenericState> {
  ResturantProfileCubit(this.repo) : super(GenericStateInit());
  final RestaurantRepo repo;
  final _log = Logger();
  void getProfileData(int id) {
    emit(GenericLoadingState());

    repo.getRestProfileData(id).then((response) {
      if (response is DioError) {
        emit(GenericErrorState());
        _log.d(response.message);
        return;
      }

      if (response['success']) {
        emit(GenericSuccessState(response['data']));
        _log.d('success');
      } else {
        emit(GenericFailureState(response['message']));
        _log.d('failed error ${response['message']}');
      }
    });
  }
}
