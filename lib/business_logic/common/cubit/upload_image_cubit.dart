import 'dart:io';

import 'package:bloc/bloc.dart';

import '../../../repos/restaurant/resturant_repo.dart';
import '../state/upload_image_state.dart';

class UploadImageCubit extends Cubit<UploadImageState> {
  UploadImageCubit(this.repo) : super(UploadImageInitial());
  final RestaurantRepo repo;
  late String url;
  void uploadImage(File file) {
    emit(LoadingState());
    repo.uploadImage(file).then((response) {
      if (response['success']) {
        url = response['url'];

        emit(SuccessState(response['url']));
      } else {
        emit(FailedState(response['message']));
      }
    });
  }
}
