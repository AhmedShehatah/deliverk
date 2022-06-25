import 'package:flutter/material.dart';

class OrderDetailsDialog extends StatelessWidget {
  const OrderDetailsDialog({Key? key}) : super(key: key);

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
                  rows: const <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('كود الطلب')),
                        DataCell(Text('19')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('حالة الطلب')),
                        DataCell(Text('قيد الانتظار')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('تكلفة التوصيل')),
                        DataCell(Text('27')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('منطقة التوصيل')),
                        DataCell(FittedBox(
                            fit: BoxFit.cover, child: Text('شارع الهرم'))),
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
