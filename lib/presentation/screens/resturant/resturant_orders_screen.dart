import '../../../business_logic/common/cubit/refresh_cubit.dart';
import '../../../business_logic/common/state/generic_state.dart';
import '../../../business_logic/common/state/reresh_state.dart';
import '../../../data/models/common/order_model.dart';
import '../../../data/models/restaurant/restaurant_model.dart';
import '../../../helpers/shared_preferences.dart';
import 'restaurant_new_order.dart';
import '../../widgets/restaurant/empty_orders.dart';
import '../../../repos/restaurant/resturant_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/common/cubit/spinner_cubit.dart';
import '../../../business_logic/restaurant/cubit/all_orders_cubit.dart';
import '../../../business_logic/restaurant/cubit/new_order_cubit.dart';
import '../../../business_logic/restaurant/cubit/restaurant_profile_cubit.dart';
import '../../widgets/restaurant/current_orders_model.dart';

class RestaurantOrdersScreen extends StatefulWidget {
  const RestaurantOrdersScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantOrdersScreen> createState() => _RestaurantOrdersScreenState();
}

class _RestaurantOrdersScreenState extends State<RestaurantOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    // setupScrollController(context);
    var provider = BlocProvider.of<AllOrdersCubit>(context);
    provider.getAllOrders();
    provider.checkUpdate();
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
    return BlocBuilder<AllOrdersCubit, GenericState>(
      builder: ((context, state) {
        if (state is GenericLoadingState) {
          return _loadingIndicator();
        } else if (state is GenericSuccessState) {
          _orders = state.data;
          if (_orders.isEmpty) return const EmptyOrders();
          return _buildListItem(dataModel);
        } else {
          return const Center(
            child: Text('حدث خطأ كما'),
          );
        }
      }),
    );
  }

  Widget _buildListItem(RestaurantModel dataModel) {
    return ListView.builder(
      // controller: _scrollController,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        if (index < _orders.length) {
          return BlocListener<RefreshCubit, RefreshState>(
            listener: (context, state) {
              refresh(this.context);
            },
            child: CurrentOrdersModel(
              _orders[index],
              dataModel,
              key: Key(_orders[index].id.toString()),
            ),
          );
        } else {
          return _loadingIndicator();
        }
      },
      itemCount: _orders.length,
    );
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> refresh(BuildContext context) async {
    final provider = BlocProvider.of<AllOrdersCubit>(context);
    _orders.clear();
    provider.getAllOrders();
  }

  // final _scrollController = ScrollController();

  // void setupScrollController(context) {
  //   _scrollController.addListener(() {
  //     if (_scrollController.position.atEdge) {
  //       if (_scrollController.position.pixels ==
  //           _scrollController.position.maxScrollExtent) {
  //         Logger().d("i got here bro");
  //         BlocProvider.of<RestaurantCurrentOrdersCubit>(context)
  //             .loadOrders(status: OrderType.pending.name);
  //       } else if (_scrollController.position.pixels ==
  //           _scrollController.position.minScrollExtent) {
  //         Logger().d('hello form mibn');
  //       }
  //     }
  //   });
  // }

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
