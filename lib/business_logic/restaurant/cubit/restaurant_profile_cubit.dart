import 'package:bloc/bloc.dart';
import '../../common/state/generic_state.dart';
import 'package:logger/logger.dart';
import '../../../repos/restaurant/resturant_repo.dart';

class ResturantProfileCubit extends Cubit<GenericState> {
  ResturantProfileCubit(this.repo) : super(GenericStateInit());
  final RestaurantRepo repo;
  final _log = Logger();
  int total = 0;
  void getProfileData(int id) {
    emit(GenericLoadingState());

    repo.getRestProfileData(id).then((response) {
      if (response['success']) {
        total = response['total'] as int;
        emit(GenericSuccessState(response['data']));
      } else {
        emit(GenericFailureState(response['message']));
        _log.d('failed error ${response['message']}');
      }
    });
  }
}
