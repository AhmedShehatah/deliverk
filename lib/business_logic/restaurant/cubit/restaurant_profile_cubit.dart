import 'package:bloc/bloc.dart';
import '../../common/state/generic_state.dart';
import 'package:logger/logger.dart';
import '../../../repos/restaurant/resturant_repo.dart';

class ResturantProfileCubit extends Cubit<GenericState> {
  ResturantProfileCubit(this.repo) : super(GenericStateInit());
  final RestaurantRepo repo;
  final _log = Logger();

  void getProfileData(int id) {
    emit(GenericLoadingState());

    repo.getRestProfileData(id).then((response) {
      if (response['success']) {
        emit(GenericSuccessState(response['data']));
      } else {
        emit(GenericFailureState(response['message']));

        _log.d('failed error ${response['message']}');
      }
    });
  }

  void patchProfile(int id, Map<String, dynamic> data) {
    emit(GenericLoadingState());

    repo.patchProfile(id, data).then((response) {
      if (response['success']) {
        emit(GenericSuccessState(response['data']));
      } else {
        emit(GenericFailureState(response['message']));

        _log.d('failed error ${response['message']}');
      }
    });
  }
}
