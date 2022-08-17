import 'package:deliverk/business_logic/common/cubit/refresh_cubit.dart';
import 'package:deliverk/business_logic/common/state/generic_state.dart';
import 'package:deliverk/business_logic/common/state/reresh_state.dart';
import 'package:deliverk/business_logic/restaurant/state/restaurant_current_orders_state.dart';
import 'package:deliverk/constants/enums.dart';
import 'package:deliverk/data/models/common/order_model.dart';
import 'package:deliverk/data/models/restaurant/restaurant_model.dart';
import 'package:deliverk/helpers/shared_preferences.dart';
import 'package:deliverk/presentation/screens/resturant/restaurant_new_order.dart';

import 'package:deliverk/presentation/widgets/restaurant/empty_orders.dart';
import 'package:deliverk/repos/restaurant/resturant_repo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/common/cubit/spinner_cubit.dart';
import '../../../business_logic/restaurant/cubit/new_order_cubit.dart';
import '../../../business_logic/restaurant/cubit/restaurant_profile_cubit.dart';
import '../../../business_logic/restaurant/cubit/restaurants_current_orders_cubit.dart';

import '../../widgets/restaurant/current_orders_model.dart';

class RestaurantOrdersScreen extends StatefulWidget {
  const RestaurantOrdersScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantOrdersScreen> createState() => _RestaurantOrdersScreenState();
}

class _RestaurantOrdersScreenState extends State<RestaurantOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    BlocProvider.of<RestaurantCurrentOrdersCubit>(context)
        .loadOrders(status: OrderType.pending.name);
    BlocProvider.of<ResturantProfileCubit>(context)
        .getProfileData(DeliverkSharedPreferences.getRestId()!);
    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(context),
      body: SafeArea(
        child: RefreshIndicator(
            onRefresh: () => refresh(context), child: _buildOrders(context)),
      ),
    );
  }

  Widget _buildOrders(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (_, innerBoxIsScrolled) => [
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
      body: BlocBuilder<ResturantProfileCubit, GenericState>(
        builder: (context, state) {
          if (state is GenericSuccessState) {
            return _buildOrdersList(RestaurantModel.fromJson(state.data));
          } else if (state is GenericFailureState) {
            return const Center(
              child: Text("حدث خطأ ما"),
            );
          } else if (state is GenericLoadingState) {
            return Center(
              child: _loadingIndicator(),
            );
          } else {
            return const Center(
              child: Text("حدث خطأ ما"),
            );
          }
        },
      ),
    );
  }

  List<OrderModel> _orders = [];
  Widget _buildOrdersList(RestaurantModel dataModel) {
    return RefreshIndicator(
      onRefresh: () => refresh(context),
      child: BlocBuilder<RestaurantCurrentOrdersCubit, CurrentOrdersState>(
        builder: ((context, state) {
          if (state is CurrentOrdersLoading && state.isFirstFetch) {
            return _loadingIndicator();
          }

          bool isLoading = false;
          if (state is CurrentOrdersLoading) {
            _orders = state.oldOrders;
            isLoading = true;
          } else if (state is CurrentOrdersLoaded) {
            _orders = state.currentOrders;
          }
          if (_orders.isEmpty) return const EmptyOrders();

          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              if (index < _orders.length) {
                return BlocListener<RefreshCubit, RefreshState>(
                  listener: (context, state) {
                    refresh(this.context);
                  },
                  child: CurrentOrdersModel(_orders[index], dataModel),
                );
              } else {
                return _loadingIndicator();
              }
            },
            itemCount: _orders.length + (isLoading ? 1 : 0),
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

  Future<void> refresh(BuildContext context) async {
    final provider = BlocProvider.of<RestaurantCurrentOrdersCubit>(context);
    provider.page = 1;
    _orders.clear();
    provider.loadOrders(status: OrderType.pending.name);
  }

  final _scrollController = ScrollController();

  void setupScrollController(context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          BlocProvider.of<RestaurantCurrentOrdersCubit>(context)
              .loadOrders(status: OrderType.pending.name);
        }
      }
    });
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: Material(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
        elevation: 18.0,
        color: Colors.blue,
        clipBehavior: Clip.antiAlias, // Add This
        child: MaterialButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.restaurant_menu,
                  color: Colors.white,
                ),
                Text('اضف طلب', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          onPressed: () {
            navigate();
          },
        ),
      ),
    );
  }

  void navigate() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider<SpinnerCubit>(
              create: (context) => SpinnerCubit(),
            ),
            BlocProvider<NewOrderCubit>(
              create: (context) => NewOrderCubit(RestaurantRepo()),
            ),
          ],
          child: const RestaurantNewOrder(),
        ),
      ),
      (route) => true,
    ).then((value) => refresh(context));
  }

  @override
  void initState() {
    super.initState();
  }
}
