import 'package:deliverk/business_logic/common/cubit/refresh_cubit.dart';
import 'package:deliverk/business_logic/common/state/reresh_state.dart';
import 'package:deliverk/business_logic/restaurant/cubit/restaurant_profile_cubit.dart';
import 'package:deliverk/presentation/widgets/restaurant/empty_orders.dart';
import 'package:deliverk/repos/restaurant/resturant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/delivery/cubit/delivery_orders_cubit.dart';
import '../../../business_logic/delivery/cubit/delivery_zone_orders_cubit.dart';
import '../../../business_logic/delivery/state/delivery_order_state.dart';
import '../../../constants/enums.dart';

import '../../../data/models/delivery/zone_order.dart';
import '../../widgets/delivery/delivery_unpaid_orders_model.dart';
import 'package:flutter/material.dart';

class DeliveryUnpaidOrdersScreen extends StatefulWidget {
  const DeliveryUnpaidOrdersScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryUnpaidOrdersScreen> createState() =>
      _DeliveryUnpaidOrdersScreenState();
}

class _DeliveryUnpaidOrdersScreenState
    extends State<DeliveryUnpaidOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    BlocProvider.of<DeliveryOrdersCubit>(context)
        .loadOrders(status: OrderType.received.name, isPaid: false);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: _buildOrders(context),
      ),
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
            title: Text('طلبات لم يتم تسليم حسابها'),
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
                    listener: (context, state) {
                      refresh();
                    },
                    child: BlocProvider<ResturantProfileCubit>(
                      create: (context) => ResturantProfileCubit(
                        RestaurantRepo(),
                      ),
                      child: DeliveryUnpaidOrdersModel(orders[index]),
                    ),
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

  List<ZoneOrder> orders = [];

  Future<void> refresh() async {
    final provider = BlocProvider.of<DeliveryOrdersCubit>(context);
    provider.page = 1;
    orders.clear();
    provider.loadOrders(status: OrderType.received.name, isPaid: false);
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  final _scrollController = ScrollController();

  void setupScrollController(context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          BlocProvider.of<DeliveryZoneOrdersCubit>(context)
              .loadOrders(status: OrderType.received.name, isPaid: false);
        }
      }
    });
  }
}
