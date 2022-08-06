import 'package:deliverk/business_logic/common/state/generic_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repos/delivery/delivery_repo.dart';

class PatchOrderCubit extends Cubit<GenericState> {
  PatchOrderCubit(this._repo) : super(GenericStateInit());
  final DeliveryRepo _repo;

  void patchOrder(int orderId, Map<String, dynamic> data) {
    emit(GenericLoadingState());

    _repo.patchOrder(orderId, data).then((response) {
      if (response['success']) {
        emit(GenericSuccessState(response['data']));
      } else {
        emit(GenericFailureState(response['message']));
      }
    });
  }
}
