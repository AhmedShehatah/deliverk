import 'package:deliverk/business_logic/common/cubit/patch_order_cubit.dart';
import 'package:deliverk/business_logic/common/cubit/refresh_cubit.dart';
import 'package:deliverk/business_logic/delivery/cubit/delivery_profile_cubit.dart';
import 'package:deliverk/data/models/common/order_model.dart';
import 'package:deliverk/data/models/restaurant/restaurant_model.dart';
import 'package:deliverk/helpers/trans.dart';
import 'package:deliverk/presentation/widgets/restaurant/order_details_dialog.dart';
import 'package:deliverk/repos/delivery/delivery_repo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive/hive.dart';

class CurrentOrdersModel extends StatefulWidget {
  const CurrentOrdersModel(this.orderModel, this.model, {Key? key})
      : super(key: key);

  final OrderModel orderModel;
  final RestaurantModel model;

  @override
  State<CurrentOrdersModel> createState() => _CurrentOrdersModelState();
}

class _CurrentOrdersModelState extends State<CurrentOrdersModel> {
  String? areaName;
  bool _isLoaded = false;
  @override
  void initState() {
    getAreaName().then((value) {
      setState(() {
        _isLoaded = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_isLoaded) {
          showDialog(
              context: context,
              builder: (c) => MultiBlocProvider(
                    providers: [
                      BlocProvider<PatchOrderCubit>(
                        create: (context) => PatchOrderCubit(DeliveryRepo()),
                      ),
                      BlocProvider<DeliveryProfileCubit>(
                        create: (context) =>
                            DeliveryProfileCubit(DeliveryRepo()),
                      ),
                    ],
                    child: OrderDetailsDialog(
                        widget.orderModel, widget.model, areaName!),
                  )).then((value) {
            if (value == true) {
              BlocProvider.of<RefreshCubit>(context, listen: false).refresh();
            }
          });
        }
      },
      child: _buildTree(),
    );
  }

  Widget _buildTree() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 5,
        child: Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("كود الطلب " + widget.orderModel.id.toString()),
                  Text(
                    areaName ?? "اسم المنطقة",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black38,
                    ),
                  ),
                  Text(
                    Trans.status[widget.orderModel.status!] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(widget.orderModel.cost == null
                      ? "مدفوع"
                      : widget.orderModel.cost.toString() + "ج.م"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getAreaName() async {
    var box = await Hive.openBox<Map<dynamic, dynamic>>('areas');
    var x = box.get('areas_id');
    x = x as Map<int, String>;
    areaName = x[widget.orderModel.areaId!] as String;
  }
}
