import 'package:deliverk/business_logic/common/state/generic_state.dart';

import 'package:deliverk/constants/enums.dart';
import 'package:deliverk/data/models/common/order_model.dart';
import 'package:deliverk/data/models/restaurant/restaurant_model.dart';
import 'package:deliverk/helpers/trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../business_logic/common/cubit/patch_order_cubit.dart';

class OrderDetailsDialog extends StatelessWidget {
  const OrderDetailsDialog(this.order, this.resData, this.areaName, {Key? key})
      : super(key: key);
  final OrderModel order;
  final RestaurantModel resData;
  final String areaName;
  @override
  Widget build(BuildContext context) {
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
                            fit: BoxFit.cover, child: Text(areaName))),
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
}
