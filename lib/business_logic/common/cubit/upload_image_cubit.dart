import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import '../../../repos/restaurant/resturant_repo.dart';
import 'package:dio/dio.dart';
import '../state/upload_image_state.dart';

class UploadImageCubit extends Cubit<UploadImageState> {
  UploadImageCubit(this.repo) : super(UploadImageInitial());
  final RestaurantRepo repo;
  late String url;
  void uploadImage(File file) {
    emit(LoadingState());
    repo.uploadImage(file).then((response) {
      if (response is DioError) {
        emit(ErrorState());
        return;
      }
      if (response['success']) {
        url = response['url'];
        Logger().d('successsssssssssssssss');
        emit(SuccessState(response['url']));
      } else {
        Logger().d(response['message']);
        emit(FailedState(response['message']));
      }
    });
  }
}
