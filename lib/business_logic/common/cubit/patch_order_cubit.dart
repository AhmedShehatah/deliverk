import '../state/generic_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../repos/delivery/delivery_repo.dart';

class PatchOrderCubit extends Cubit<GenericState> {
  PatchOrderCubit(this._repo) : super(GenericStateInit());
  final DeliveryRepo _repo;

  void patchOrder(int orderId, Map<String, dynamic> data, {String? booking}) {
    emit(GenericLoadingState());
    Logger().d(orderId, data);
    _repo.patchOrder(orderId, data, booking: booking).then((response) {
      if (response['success']) {
        emit(GenericSuccessState(response['data']));
      } else {
        emit(GenericFailureState(response['message']));
        Logger().d(response['message']);
      }
    });
  }

  void deleteOrder(int orderId) {
    emit(GenericLoadingState());

    _repo.deleteOrder(orderId).then((response) {
      if (response['success']) {
        emit(GenericSuccessState(''));
      } else {
        emit(GenericFailureState(response['message']));
      }
    });
  }
}
