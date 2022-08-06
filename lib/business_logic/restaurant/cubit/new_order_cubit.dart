import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../repos/restaurant/resturant_repo.dart';
import '../../common/state/generic_state.dart';

class NewOrderCubit extends Cubit<GenericState> {
  NewOrderCubit(this.repo) : super(GenericStateInit());
  final RestaurantRepo repo;
  final _log = Logger();
  void addOrder(Map<String, dynamic> data, String token) {
    emit(GenericLoadingState());

    repo.addOrder(data, token).then((response) {
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
