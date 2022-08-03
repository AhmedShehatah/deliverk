import 'package:deliverk/data/models/common/order_model.dart';
import 'package:flutter/material.dart';

class OrderDetailsDialog extends StatelessWidget {
  const OrderDetailsDialog(this.order, {Key? key}) : super(key: key);
  final OrderModel order;
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
                        DataCell(Text(order.status!)),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('تكلفة التوصيل')),
                        DataCell(Text(order.cost.toString())),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('منطقة التوصيل')),
                        DataCell(FittedBox(
                            fit: BoxFit.cover,
                            child: Text(order.areaId.toString()))),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: const Text("حذف"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
