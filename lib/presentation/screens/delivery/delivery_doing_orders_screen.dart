import '../../../business_logic/common/cubit/refresh_cubit.dart';
import '../../../business_logic/common/state/generic_state.dart';
import '../../../business_logic/common/state/reresh_state.dart';
import '../../../business_logic/delivery/cubit/delivery_all_orders_cubit.dart';

import '../../../data/models/delivery/zone_order.dart';
import '../../widgets/restaurant/empty_orders.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

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
    var provider = BlocProvider.of<DeliveryAllOrdersCubit>(context);
    provider.loadOrders(status: OrderType.pending.name);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
            onRefresh: () => refresh(), child: _buildOrders(context)),
      ),
    );
  }

  List<ZoneOrder> orders = [];

  Future<void> refresh() async {
    final provider = BlocProvider.of<DeliveryAllOrdersCubit>(context);
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

  int firstFetch = 0;
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
        child: BlocBuilder<DeliveryAllOrdersCubit, GenericState>(
          builder: (context, state) {
            firstFetch++;
            if (state is GenericLoadingState) {
              return _loadingIndicator();
            } else if (state is GenericSuccessState) {
              orders = state.data;
              if (orders.isEmpty) return const EmptyOrders();
              return _buildListItem();
            } else {
              return const Center(
                child: Text('حدث خطأ كما'),
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
              listener: (_, state) {
                if (state is Refresh) {
                  Logger().d('refreshed');
                  refresh();
                }
              },
              child: BlocProvider<ResturantProfileCubit>(
                create: (context) => ResturantProfileCubit(RestaurantRepo()),
                child: DeliveryCurrentOrderModel(
                    orders[index], true, firstFetch == 1),
              ));
        } else {
          return _loadingIndicator();
        }
      },
      itemCount: orders.length,
    );
  }

  @override
  void initState() {
    BlocProvider.of<DeliveryAllOrdersCubit>(context).update();
    super.initState();
  }

  final _scrollController = ScrollController();

  void setupScrollController(context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          BlocProvider.of<DeliveryAllOrdersCubit>(context)
              .loadOrders(status: OrderType.pending.name);
        }
      }
    });
  }
}
