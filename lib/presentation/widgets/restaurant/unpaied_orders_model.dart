import 'package:deliverk/business_logic/common/state/generic_state.dart';

import 'package:deliverk/data/models/common/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../business_logic/common/cubit/patch_order_cubit.dart';

class UnpaiedOrdersModel extends StatelessWidget {
  const UnpaiedOrdersModel(this.order, {Key? key}) : super(key: key);
  final OrderModel order;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Card(
          elevation: 5,
          child: Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("كود الطلب: ${order.id!}"),
                    Text(
                      order.delvId.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black38,
                      ),
                    ),
                    Text(order.cost.toString()),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: BlocBuilder<PatchOrderCubit, GenericState>(
                        builder: (context, state) {
                          if (state is GenericSuccessState) {
                            Fluttertoast.showToast(msg: 'تمت العملية بنجاح');
                          } else if (state is GenericLoadingState) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            );
                          } else if (state is GenericFailureState) {
                            Fluttertoast.showToast(msg: state.data);
                          }
                          return FloatingActionButton(
                            backgroundColor: Colors.green,
                            onPressed: () {
                              BlocProvider.of<PatchOrderCubit>(context)
                                  .patchOrder(order.id!, {'isPaid': true});
                            },
                            child: const Icon(Icons.check),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
