import 'dart:async';

import 'package:deliverk/business_logic/delivery/cubit/delivery_zone_orders_cubit.dart';
import 'package:deliverk/business_logic/delivery/state/delivery_zone_orders_state.dart';
import 'package:deliverk/business_logic/restaurant/cubit/restaurant_profile_cubit.dart';
import 'package:deliverk/data/models/delivery/zone_order.dart';
import 'package:deliverk/repos/restaurant/resturant_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/enums.dart';

import '../../widgets/delivery/delivery_current_orders_model.dart';

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
    setupScrollController(context);
    BlocProvider.of<DeliveryZoneOrdersCubit>(context)
        .loadOrders(status: OrderType.pending.name);

    return Scaffold(
      body: SafeArea(
        child: _buildOrders(context),
      ),
    );
  }

  List<ZoneOrder> orders = [];

  Future<void> refresh() async {
    final provider = BlocProvider.of<DeliveryZoneOrdersCubit>(context);
    provider.page = 1;
    orders.clear();
    provider.loadOrders(status: OrderType.pending.name);
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
        child: BlocBuilder<DeliveryZoneOrdersCubit, ZoneOrdersState>(
          builder: (context, state) {
            if (state is ZoneOrdersLoading && state.isFirstFetch) {
              return _loadingIndicator();
            }

            bool isLoading = false;
            if (state is ZoneOrdersLoading) {
              orders = state.oldOrders;
              isLoading = true;
            } else if (state is ZoneOrdersLoaded) {
              orders = state.currentOrders;
            }

            return ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, int index) {
                if (index < orders.length) {
                  return BlocProvider<ResturantProfileCubit>(
                    create: (context) =>
                        ResturantProfileCubit(RestaurantRepo()),
                    child: DeliveryCurrentOrderModel(orders[index], false),
                  );
                } else {
                  return _loadingIndicator();
                }
              },
              itemCount: orders.length + (isLoading ? 1 : 0),
            );
          },
        ),
      ),
    );
  }

  final _scrollController = ScrollController();

  void setupScrollController(context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          BlocProvider.of<DeliveryZoneOrdersCubit>(context)
              .loadOrders(status: OrderType.pending.name);
        }
      }
    });
  }
}
