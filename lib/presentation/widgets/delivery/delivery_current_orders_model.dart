import '../../../business_logic/common/cubit/patch_order_cubit.dart';
import '../../../business_logic/common/cubit/refresh_cubit.dart';
import '../../../business_logic/common/state/generic_state.dart';
import '../../../business_logic/restaurant/cubit/restaurant_profile_cubit.dart';
import '../../../data/models/restaurant/restaurant_model.dart';
import '../../../helpers/trans.dart';
import '../common/shimmer_widget.dart';
import '../../../repos/delivery/delivery_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'deliver_order_dilaog.dart';

class DeliveryCurrentOrderModel extends StatefulWidget {
  const DeliveryCurrentOrderModel(
      this.order, this.isDelivering, this.firstFetch,
      {Key? key})
      : super(key: key);
  final dynamic order;
  final bool isDelivering;
  final bool firstFetch;
  @override
  State<DeliveryCurrentOrderModel> createState() =>
      _DeliveryCurrentOrderModelState();
}

class _DeliveryCurrentOrderModelState extends State<DeliveryCurrentOrderModel> {
  bool _isLoaded = false;
  late RestaurantModel model;
  late String areaName;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ResturantProfileCubit>(context)
        .getProfileData(widget.order.resId!);
    return InkWell(
      child: _buildTree(),
      onTap: () {
        if (_isLoaded) {
          getAreaName().then((value) {
            showDialog(
                context: context,
                builder: (c) => BlocProvider<PatchOrderCubit>(
                      create: (context) => PatchOrderCubit(DeliveryRepo()),
                      child: DeliveryOrderDetialsDialog(
                          widget.order, model, areaName, widget.isDelivering),
                    )).then((value) {
              if (value == true) {
                BlocProvider.of<RefreshCubit>(context, listen: false).refresh();
              }
            });
          });
        }
      },
    );
  }

  Widget _buildTree() {
    return BlocBuilder<ResturantProfileCubit, GenericState>(
      builder: (context, state) {
        if (state is GenericSuccessState) {
          var restData = RestaurantModel.fromJson(state.data);
          _isLoaded = true;
          model = restData;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                elevation: 5,
                child: SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildRestaurantPhoto(restData.avatar!),
                      const SizedBox(
                        width: 10,
                      ),
                      _buildDetials(restData.address!, restData.name!),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(widget.order.cost == null
                            ? 'مدفوع'
                            : widget.order.cost.toString() + "ج.م"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state is GenericLoadingState) {
          return const ShimmerWidget();
        } else {
          return const Center(child: Text('Error Happened Please Try Again'));
        }
      },
    );
  }

  Widget _buildRestaurantPhoto(String logo) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
      child: SizedBox(
        width: 100,
        height: 100,
        child: FadeInImage(
          fit: BoxFit.cover,
          image: NetworkImage(logo),
          placeholder: const AssetImage('assets/images/loading.gif'),
        ),
      ),
    );
  }

  Widget _buildDetials(String address, String name) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 13),
        ),
        Text(
          Trans.status[widget.order.status!] as String,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(
          width: 150,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              address,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Future getAreaName() async {
    var box = await Hive.openBox<Map<dynamic, dynamic>>('areas');
    var x = box.get('areas_id');
    x = x as Map<int, String>;
    areaName = x[widget.order.areaId!] as String;
  }
}
