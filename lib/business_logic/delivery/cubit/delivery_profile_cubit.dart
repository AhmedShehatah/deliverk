import 'package:deliverk/repos/delivery/delivery_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../common/state/generic_state.dart';

class DeliveryProfileCubit extends Cubit<GenericState> {
  DeliveryProfileCubit(this.repo) : super(GenericStateInit());
  final DeliveryRepo repo;
  final _log = Logger();
  void getProfileData(int id) {
    emit(GenericLoadingState());

    repo.getProflieData(id).then((response) {
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
