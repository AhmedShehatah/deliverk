import 'package:deliverk/business_logic/common/cubit/patch_order_cubit.dart';
import 'package:deliverk/business_logic/common/state/generic_state.dart';
import 'package:deliverk/business_logic/restaurant/cubit/restaurant_profile_cubit.dart';
import 'package:deliverk/data/models/restaurant/restaurant_model.dart';
import 'package:deliverk/presentation/widgets/common/shimmer_widget.dart';
import 'package:deliverk/repos/delivery/delivery_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'deliver_order_dilaog.dart';

class DeliveryCurrentOrderModel extends StatefulWidget {
  const DeliveryCurrentOrderModel(this.order, this.isDelivering, {Key? key})
      : super(key: key);
  final dynamic order;
  final bool isDelivering;
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
                    ));
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
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: double.infinity,
                        child: Text(widget.order.cost == null
                            ? 'مدفوع'
                            : widget.order.cost.toString() + "ج.م"),
                      )
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
          widget.order.status == "cooked" ? 'جاهز' : 'جاري التجهيز',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          address,
          style: const TextStyle(fontSize: 13),
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
