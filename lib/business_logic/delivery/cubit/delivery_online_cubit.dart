import 'package:bloc/bloc.dart';
import '../../common/state/generic_state.dart';
import '../../../data/models/delivery/delivery_model.dart';
import '../../../repos/delivery/delivery_repo.dart';

class DeliveryOnlineCubit extends Cubit<GenericState> {
  DeliveryOnlineCubit(this._repo) : super(GenericStateInit());
  final DeliveryRepo _repo;

  void online(bool status) {
    emit(GenericLoadingState());
    _repo.online(status).then((response) {
      if (response['success']) {
        var data = DeliveryModel.fromJson(response['data']);
        emit(GenericSuccessState(data.online));
      } else {
        emit(GenericFailureState(response['message']));
      }
    });
  }
}
