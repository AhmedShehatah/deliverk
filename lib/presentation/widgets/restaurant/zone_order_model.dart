import 'package:deliverk/business_logic/restaurant/cubit/restaurant_profile_cubit.dart';
import 'package:deliverk/data/models/restaurant/restaurant_model.dart';
import '../../../business_logic/common/cubit/patch_order_cubit.dart';
import '../../../business_logic/common/state/generic_state.dart';
import '../../../constants/enums.dart';
import '../../../data/models/delivery/zone_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

import 'package:shimmer/shimmer.dart';

import '../../../business_logic/common/cubit/refresh_cubit.dart';

class ZoneOrderModel extends StatefulWidget {
  const ZoneOrderModel(this.order, {Key? key}) : super(key: key);
  final ZoneOrder order;

  @override
  State<ZoneOrderModel> createState() => _ZoneOrderModelState();
}

class _ZoneOrderModelState extends State<ZoneOrderModel> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.order.id.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          title: Column(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: areaName == null
                    ? Shimmer.fromColors(
                        child: const Text('اسم المنطقة'),
                        baseColor: Colors.black,
                        highlightColor: Colors.white)
                    : Text(areaName!),
              ),
              BlocBuilder<ResturantProfileCubit, GenericState>(
                  builder: (_, state) {
                if (state is GenericSuccessState) {
                  var info = RestaurantModel.fromJson(state.data);
                  return Text(info.name!);
                } else {
                  return const Text('جاري تحميل اسم المطعم...');
                }
              }),
            ],
          ),
          trailing: BlocConsumer<PatchOrderCubit, GenericState>(
            listener: ((context, state) {
              if (state is GenericSuccessState) {
                Fluttertoast.showToast(msg: 'تم حجز الطلب بنجاح');
                BlocProvider.of<RefreshCubit>(context).refresh();
              } else if (state is GenericFailureState) {
                Fluttertoast.showToast(msg: state.data);
              }
            }),
            builder: (context, state) {
              if (state is GenericLoadingState) {
                return const Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              }
              return ElevatedButton(
                child: const Text('قبول'),
                onPressed: () {
                  BlocProvider.of<PatchOrderCubit>(context).patchOrder(
                      widget.order.id!,
                      {
                        'status': OrderType.coming.name,
                      },
                      booking: "/booking");
                },
              );
            },
          ),
        ),
      ),
    );
  }

  String? areaName;
  void getAreaName() {
    Hive.openBox<Map<dynamic, dynamic>>('areas').then((value) {
      var x = value.get('areas_id');
      x = x as Map<int, String>;

      setState(() {
        areaName = x![widget.order.areaId] as String;
      });
    });
  }

  @override
  void initState() {
    getAreaName();
    BlocProvider.of<ResturantProfileCubit>(context)
        .getProfileData(widget.order.resId!);
    super.initState();
  }
}
