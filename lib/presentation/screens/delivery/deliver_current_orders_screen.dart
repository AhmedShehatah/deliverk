import 'dart:async';

import '../../../business_logic/common/cubit/patch_order_cubit.dart';
import '../../../business_logic/common/cubit/refresh_cubit.dart';
import '../../../business_logic/common/state/generic_state.dart';
import '../../../business_logic/common/state/reresh_state.dart';
import '../../../business_logic/delivery/cubit/delivery_zone_orders_cubit.dart';

import '../../../business_logic/restaurant/cubit/restaurant_profile_cubit.dart';
import '../../../data/models/delivery/zone_order.dart';
import '../../widgets/restaurant/zone_order_model.dart';
import '../../../repos/delivery/delivery_repo.dart';
import '../../../repos/restaurant/resturant_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/restaurant/empty_orders.dart';

class DeliveryCurrentOrdersScreen extends StatefulWidget {
  const DeliveryCurrentOrdersScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryCurrentOrdersScreen> createState() =>
      _DeliveryCurrentOrdersScreenState();
}

class _DeliveryCurrentOrdersScreenState
    extends State<DeliveryCurrentOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = BlocProvider.of<DeliveryZoneOrdersCubit>(context);

    provider.loadOrders();
    provider.checkNewOrders();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
            onRefresh: () => refresh(), child: _buildOrders(context)),
      ),
    );
  }

  List<ZoneOrder> orders = [];

  Future<void> refresh() async {
    final provider = BlocProvider.of<DeliveryZoneOrdersCubit>(context);

    orders.clear();
    provider.loadOrders();
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildOrders(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: false,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        const SliverAppBar(
          pinned: true,
          centerTitle: true,
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text('الطلبات الحالية'),
          ),
        ),
      ],
      body: RefreshIndicator(
        onRefresh: refresh,
        child: BlocBuilder<DeliveryZoneOrdersCubit, GenericState>(
          builder: (context, state) {
            if (state is GenericLoadingState) {
              return _loadingIndicator();
            } else if (state is GenericSuccessState) {
              orders.clear();
              orders = state.data;
              if (orders.isEmpty) return const EmptyOrders();
              return _buildListItem();
            } else {
              return const Center(
                child: Text('حدث خطا ما من فضلك اعد المحاولة'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildListItem() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        if (index < orders.length) {
          return BlocListener<RefreshCubit, RefreshState>(
            listener: (context, state) {
              refresh();
            },
            child: MultiBlocProvider(
              providers: [
                BlocProvider<ResturantProfileCubit>(
                  create: (context) => ResturantProfileCubit(RestaurantRepo()),
                ),
                BlocProvider<PatchOrderCubit>(
                  create: (context) => PatchOrderCubit(DeliveryRepo()),
                ),
              ],
              child: ZoneOrderModel(orders[index]),
            ),
          );
        } else {
          return _loadingIndicator();
        }
      },
      itemCount: orders.length,
    );
  }
}
