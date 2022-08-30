import 'package:deliverk/helpers/shared_preferences.dart';
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
      if (response['success']) {
        NotificationSender().sendNotification();
        emit(GenericSuccessState(response['data']));
      } else {
        emit(GenericFailureState(response['message']));
        _log.d('failed error ${response['message']}');
      }
    });
  }
}

class NotificationSender {
  final zoneId = DeliverkSharedPreferences.getZoneId()!;

  void sendNotification() async {
    Map<String, dynamic> body = {
      "to": "/topics/$zoneId",
      "notification": {
        "title": "انتباه",
        "body": "هناك طلب جديد",
      },
      "data": {
        "title": "انتباه",
        "body": "هناك طلب جديد",
      },
    };

    BaseOptions options = BaseOptions(
      baseUrl: "https://fcm.googleapis.com/fcm/",
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000, // 60 seconds,
      receiveTimeout: 20 * 1000,
    );
    Dio dio = Dio(options);

    await dio.post(
      'send',
      data: body,
      options: Options(headers: {
        'Authorization':
            'key=AAAAnyeexlE:APA91bGPwahSzJJqJpPAPnz86J88MQacurDopYiFQk1Nn3kVHwydRRemumb_Ez8uMpynP9Rq-y8rr-ENGpjbq07kQbmcVHTq1xKo4qJM5RJa6DVpScNmjzZL1AYGSS2gxQS4RLrXJGTf',
      }),
    );
  }
}
