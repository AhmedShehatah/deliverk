import 'package:url_launcher/url_launcher.dart';

import '../../../business_logic/common/cubit/refresh_cubit.dart';
import '../../../business_logic/common/state/generic_state.dart';
import '../../../business_logic/delivery/cubit/delivery_profile_cubit.dart';

import '../../../data/models/common/order_model.dart';
import '../../../data/models/delivery/delivery_model.dart';
import '../../../repos/delivery/delivery_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

import '../../../business_logic/common/cubit/patch_order_cubit.dart';

class UnpaiedOrdersModel extends StatefulWidget {
  const UnpaiedOrdersModel(this.order, {Key? key}) : super(key: key);
  final OrderModel order;

  @override
  State<UnpaiedOrdersModel> createState() => _UnpaiedOrdersModelState();
}

class _UnpaiedOrdersModelState extends State<UnpaiedOrdersModel> {
  DeliveryModel? data;

  @override
  Widget build(BuildContext context) {
    if (widget.order.delvId != null) {
      BlocProvider.of<DeliveryProfileCubit>(context)
          .getProfileData(widget.order.delvId);
    }
    return InkWell(
      onTap: () {
        showAlertDialog(context);
      },
      child: Directionality(
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
                      Text("كود الطلب: ${widget.order.id!}"),
                      BlocBuilder<DeliveryProfileCubit, GenericState>(
                        builder: (context, state) {
                          if (state is GenericSuccessState) {
                            data = DeliveryModel.fromJson(state.data);
                            return Text(
                              data != null ? data!.name! : 'لا يوجد ديليفري',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black38,
                              ),
                            );
                          } else if (state is GenericLoadingState) {
                            return Shimmer.fromColors(
                                child: Container(
                                  width: 20,
                                  height: 15,
                                  color: Colors.black,
                                ),
                                baseColor: Colors.grey,
                                highlightColor: Colors.white);
                          } else {
                            return const Text('لم يسلم لديلفري بعد');
                          }
                        },
                      ),
                      Text(widget.order.cost.toString() + "ج.م"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("لا"),
      onPressed: () {
        Navigator.of(context).maybePop();
      },
    );
    Widget callDelivery = TextButton(
      onPressed: () {
        launchUrl(Uri(scheme: 'tel', path: data!.phone));
      },
      child: const Text('اتصل بالديلفري'),
    );
    Widget continueButton = BlocBuilder<PatchOrderCubit, GenericState>(
      builder: (context, state) {
        if (state is GenericSuccessState) {
          Fluttertoast.showToast(msg: 'تمت العملية بنجاح');

          Navigator.of(context).maybePop(true);
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
        return TextButton(
          child: const Text("نعم"),
          onPressed: () {
            BlocProvider.of<PatchOrderCubit>(context)
                .patchOrder(widget.order.id!, {'isPaid': true});
          },
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("طلب تاكيد"),
      content: const Text('هل تريد تاكيد الدفع؟'),
      actions: [
        if (data != null) callDelivery,
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider<PatchOrderCubit>(
          create: (context) => PatchOrderCubit(DeliveryRepo()),
          child: alert,
        );
      },
    ).then((value) {
      if (value == true) {
        BlocProvider.of<RefreshCubit>(context, listen: false).refresh();
      }
    });
  }
}
