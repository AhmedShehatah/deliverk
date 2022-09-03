import 'package:deliverk/helpers/time_cal.dart';

import '../../../business_logic/common/state/generic_state.dart';
import '../../../data/models/common/order_model.dart';
import '../../../data/models/delivery/delivery_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'package:shimmer/shimmer.dart';

import '../../../business_logic/delivery/cubit/delivery_profile_cubit.dart';

class RecordItemModel extends StatefulWidget {
  const RecordItemModel(this.order, {Key? key}) : super(key: key);
  final OrderModel order;

  @override
  State<RecordItemModel> createState() => _RecordItemModelState();
}

class _RecordItemModelState extends State<RecordItemModel> {
  @override
  void initState() {
    getAreaName();
    BlocProvider.of<DeliveryProfileCubit>(context)
        .getProfileData(widget.order.delvId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryProfileCubit, GenericState>(
      builder: (context, state) {
        if (state is GenericSuccessState) {
          var data = DeliveryModel.fromJson(state.data);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      widget.order.id.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                title: Text(data.name!),
                trailing: Text(widget.order.areaCost.toString() + "ج.م"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(areaName ?? ""),
                    FutureBuilder(
                        future: TimeCalc.showTime(widget.order.createdAt!),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data.toString());
                          } else {
                            return const Text('جاري تحميل التاريخ');
                          }
                        }))
                  ],
                ),
              ),
            ),
          );
        } else if (state is GenericLoadingState) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Card(
              child: Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.grey,
                child: ListTile(
                  leading: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                  ),
                  title: Container(
                    width: 40,
                    height: 15,
                    color: Colors.black,
                  ),
                  trailing: Container(
                    width: 15,
                    height: 15,
                    color: Colors.black,
                  ),
                  subtitle: Container(
                    width: 60,
                    height: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Text('');
        }
      },
    );
  }

  String? areaName;

  getAreaName() async {
    var box = await Hive.openBox<Map<dynamic, dynamic>>('areas');
    var x = box.get('areas_id');
    x = x as Map<int, String>;

    setState(() {
      areaName = x![widget.order.areaId!] as String;
    });
  }
}
