import '../../../business_logic/common/state/generic_state.dart';
import '../../../business_logic/restaurant/cubit/restaurant_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/models/delivery/zone_order.dart';
import '../../../data/models/restaurant/restaurant_model.dart';

class DeliveryUnpaidOrdersModel extends StatelessWidget {
  const DeliveryUnpaidOrdersModel(this.order, {Key? key}) : super(key: key);
  final ZoneOrder order;
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ResturantProfileCubit>(context)
        .getProfileData(order.resId!);
    return BlocBuilder<ResturantProfileCubit, GenericState>(
        builder: ((context, state) {
      if (state is GenericSuccessState) {
        var restData = RestaurantModel.fromJson(state.data);

        return _buildOrder(restData);
      } else if (state is GenericLoadingState) {
        return _buildShimmer();
      } else {
        return const Center(
          child: Text('Error Happened'),
        );
      }
    }));
  }

  Widget _buildOrder(RestaurantModel restData) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Card(
          elevation: 5,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: 30,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    order.id.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            title: Text(restData.name!),
            subtitle: Text(order.cost.toString() + "ج.م"),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Card(
          elevation: 5,
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade400,
            highlightColor: Colors.white,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
              ),
              title: Container(
                width: 100,
                height: 15,
                color: Colors.white,
              ),
              subtitle: Container(
                width: 50,
                height: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
