import 'package:cached_network_image/cached_network_image.dart';
import '../../../business_logic/common/state/generic_state.dart';
import '../../../business_logic/delivery/cubit/delivery_profile_cubit.dart';

import '../../../constants/enums.dart';
import '../../../data/models/common/order_model.dart';
import '../../../data/models/delivery/delivery_model.dart';
import '../../../data/models/restaurant/restaurant_model.dart';
import '../../../helpers/time_cal.dart';
import '../../../helpers/trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shimmer/shimmer.dart';

import '../../../business_logic/common/cubit/patch_order_cubit.dart';

class OrderDetailsDialog extends StatelessWidget {
  const OrderDetailsDialog(this.order, this.resData, this.areaName, {Key? key})
      : super(key: key);
  final OrderModel order;
  final RestaurantModel resData;
  final String areaName;
  @override
  Widget build(BuildContext context) {
    if (order.delvId != null) {
      BlocProvider.of<DeliveryProfileCubit>(context)
          .getProfileData(order.delvId);
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (order.delvId != null) _buildDeliveryInfo(),
                DataTable(
                  horizontalMargin: 10,
                  columns: const [
                    DataColumn(
                      label: Text(
                        'بيانات الطلب',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'القيمة',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                  rows: <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('كود الطلب')),
                        DataCell(Text(order.id.toString())),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('تاريخ الطلب')),
                        DataCell(Text("منذ " +
                            TimeCalc.calcTime(order.createdAt!).toString() +
                            " دقيقة")),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('حالة الطلب')),
                        DataCell(Text(Trans.status[order.status!] as String)),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('تكلفة التوصيل')),
                        DataCell(Text(order.areaCost.toString())),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('منطقة التوصيل')),
                        DataCell(FittedBox(
                            fit: BoxFit.scaleDown, child: Text(areaName))),
                      ],
                    ),
                    if (order.notes != null)
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('ملاحظات')),
                          DataCell(FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(order.notes!))),
                        ],
                      ),
                  ],
                ),
                BlocBuilder<PatchOrderCubit, GenericState>(
                  builder: (context, state) {
                    if (state is GenericLoadingState) {
                      return const CircularProgressIndicator(
                        color: Colors.blue,
                      );
                    } else if (state is GenericFailureState) {
                      Fluttertoast.showToast(msg: state.data);
                      return _buildActionButton(context);
                    } else if (state is GenericSuccessState) {
                      Fluttertoast.showToast(msg: 'تمت العملية بنجاح');
                      Navigator.of(context).pop(true);
                    }
                    return _buildActionButton(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (order.status == OrderType.cooked.name ||
            order.status == OrderType.cooking.name)
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<PatchOrderCubit>(context).deleteOrder(order.id!);
            },
            style: ElevatedButton.styleFrom(primary: Colors.red),
            child: const Text("حذف"),
          ),
        if (order.status == OrderType.coming.name)
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<PatchOrderCubit>(context)
                  .patchOrder(order.id!, {'status': 'delivering'});
            },
            style: ElevatedButton.styleFrom(primary: Colors.green),
            child: const Text("تأكيد الوصول"),
          )
      ],
    );
  }

  Widget _buildDeliveryInfo() {
    return BlocBuilder<DeliveryProfileCubit, GenericState>(
      builder: (context, state) {
        if (state is GenericSuccessState) {
          final data = DeliveryModel.fromJson(state.data);
          return ListTile(
            leading: CachedNetworkImage(
              imageUrl: data.avatar!,
              imageBuilder: (context, imageProvider) => Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.white,
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey.shade600,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            title: Text(data.name!),
            subtitle: Text(data.phone!),
          );
        } else if (state is GenericLoadingState) {
          return Shimmer.fromColors(
            child: ListTile(
              leading: Container(
                width: 80.0,
                height: 80.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              ),
              title: Container(
                width: 40,
                height: 15,
                color: Colors.grey,
              ),
              subtitle: Container(
                width: 60,
                height: 15,
                color: Colors.grey,
              ),
            ),
            baseColor: Colors.grey,
            highlightColor: Colors.white,
          );
        } else {
          return const Text('خطا في تحميل بيانات الديلفري');
        }
      },
    );
  }
}
