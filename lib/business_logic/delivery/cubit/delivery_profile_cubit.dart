import '../../../repos/delivery/delivery_repo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/state/generic_state.dart';

class DeliveryProfileCubit extends Cubit<GenericState> {
  DeliveryProfileCubit(this.repo) : super(GenericStateInit());
  final DeliveryRepo repo;

  int total = 0;

  void getProfileData(int id) {
    emit(GenericLoadingState());

    repo.getProflieData(id).then((response) {
      if (response['success']) {
        total = response['total'] as int;
        emit(GenericSuccessState(response['data']));
      } else {
        emit(GenericFailureState(response['message']));
      }
    });
  }
}
