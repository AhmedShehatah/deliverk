import 'package:deliverk/business_logic/common/cubit/refresh_cubit.dart';
import 'package:deliverk/business_logic/common/state/reresh_state.dart';

import 'package:deliverk/data/models/delivery/zone_order.dart';
import 'package:deliverk/presentation/widgets/restaurant/empty_orders.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../business_logic/delivery/cubit/delivery_orders_cubit.dart';

import '../../../business_logic/delivery/state/delivery_order_state.dart';

import '../../../business_logic/restaurant/cubit/restaurant_profile_cubit.dart';
import '../../../constants/enums.dart';
import '../../../repos/restaurant/resturant_repo.dart';

import '../../widgets/delivery/delivery_current_orders_model.dart';

class DeliveryDoingOrderScreen extends StatefulWidget {
  const DeliveryDoingOrderScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryDoingOrderScreen> createState() =>
      _DeliveryDoingOrderScreenState();
}

class _DeliveryDoingOrderScreenState extends State<DeliveryDoingOrderScreen> {
  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    BlocProvider.of<DeliveryOrdersCubit>(context)
        .loadOrders(status: OrderType.pending.name);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
            onRefresh: () => refresh(), child: _buildOrders(context)),
      ),
    );
  }

  List<ZoneOrder> orders = [];

  Future<void> refresh() async {
    final provider = BlocProvider.of<DeliveryOrdersCubit>(context);
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
            title: Text('الطلبات جارية التسليم'),
          ),
        ),
      ],
      body: RefreshIndicator(
        onRefresh: refresh,
        child: BlocBuilder<DeliveryOrdersCubit, DeliveryOrdersState>(
          builder: (context, state) {
            if (state is DeliveryOrdersLoading && state.isFirstFetch) {
              return _loadingIndicator();
            }

            bool isLoading = false;
            if (state is DeliveryOrdersLoading) {
              orders = state.oldOrders;
              isLoading = true;
            } else if (state is DeliveryOrdersLoaded) {
              orders = state.currentOrders;
            }

            if (orders.isEmpty) return const EmptyOrders();
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, int index) {
                if (index < orders.length) {
                  return BlocListener<RefreshCubit, RefreshState>(
                      listener: (_, state) {
                        if (state is Refresh) {
                          Logger().d('refreshed');
                          refresh();
                        }
                      },
                      child: BlocProvider<ResturantProfileCubit>(
                        create: (context) =>
                            ResturantProfileCubit(RestaurantRepo()),
                        child: DeliveryCurrentOrderModel(orders[index], true),
                      ));
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
          BlocProvider.of<DeliveryOrdersCubit>(context)
              .loadOrders(status: OrderType.pending.name);
        }
      }
    });
  }
}
