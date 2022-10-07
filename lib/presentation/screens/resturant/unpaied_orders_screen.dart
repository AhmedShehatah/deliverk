import '../../../business_logic/common/cubit/patch_order_cubit.dart';
import '../../../business_logic/common/cubit/refresh_cubit.dart';
import '../../../business_logic/common/state/reresh_state.dart';
import '../../../business_logic/delivery/cubit/delivery_profile_cubit.dart';
import '../../../data/models/common/order_model.dart';
import '../../widgets/restaurant/empty_orders.dart';
import '../../../repos/delivery/delivery_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/restaurant/cubit/restaurants_current_orders_cubit.dart';
import '../../../business_logic/restaurant/state/restaurant_current_orders_state.dart';

import '../../widgets/restaurant/unpaied_orders_model.dart';

// ignore: must_be_immutable
class UnpaiedOrdersScreen extends StatelessWidget {
  UnpaiedOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    BlocProvider.of<RestaurantCurrentOrdersCubit>(context)
        .loadOrders(isPaid: false);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => refresh(context),
          child: _buildOrders(context),
        ),
      ),
    );
  }

  Future<void> refresh(BuildContext context) async {
    final provider = BlocProvider.of<RestaurantCurrentOrdersCubit>(context);
    provider.page = 1;
    orders.clear();
    provider.loadOrders(isPaid: false);
  }

  Widget _buildOrders(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: false,
      headerSliverBuilder: (_, innerBoxIsScrolled) => [
        const SliverAppBar(
          pinned: true,
          centerTitle: true,
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text('طلبات غير مدفوعة'),
          ),
        ),
      ],
      body: _buildOrdersList(context),
    );
  }

  List<OrderModel> orders = [];
  Widget _buildOrdersList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => refresh(context),
      child: BlocBuilder<RestaurantCurrentOrdersCubit, CurrentOrdersState>(
        builder: ((_, state) {
          if (state is CurrentOrdersLoading && state.isFirstFetch) {
            return _loadingIndicator();
          }

          bool isLoading = false;

          if (state is CurrentOrdersLoading) {
            orders = state.oldOrders;
            isLoading = true;
          } else if (state is CurrentOrdersLoaded) {
            orders = state.currentOrders;
          }

          if (orders.isEmpty) return const EmptyOrders();

          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              if (index < orders.length) {
                return BlocListener<RefreshCubit, RefreshState>(
                  listener: (_, state) {
                    refresh(context);
                  },
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider<PatchOrderCubit>(
                        create: (context) => PatchOrderCubit(DeliveryRepo()),
                      ),
                      BlocProvider<DeliveryProfileCubit>(
                        create: (context) =>
                            DeliveryProfileCubit(DeliveryRepo()),
                      ),
                    ],
                    child: UnpaiedOrdersModel(orders[index]),
                  ),
                );
              } else {
                return _loadingIndicator();
              }
            },
            itemCount: orders.length + (isLoading ? 1 : 0),
          );
        }),
      ),
    );
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
          BlocProvider.of<RestaurantCurrentOrdersCubit>(context)
              .loadOrders(isPaid: false);
        }
      }
    });
  }
}
