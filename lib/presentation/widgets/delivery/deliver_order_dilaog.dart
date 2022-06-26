import 'package:flutter/material.dart';

class DeliveryOrderDetialsDialog extends StatelessWidget {
  const DeliveryOrderDetialsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
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
                    _rowData(" اسم المطعم", "السوري"),
                    _rowData(
                        "مكان المطعم", "شارع النزهة بجوار دار الدفاع الجوي "),
                    _rowData("مكان المطعم", "اظهر على الخريطة"),
                    _rowData("كود الطلب", "1553"),
                    _rowData("تكلفة التوصيل", "27"),
                    _rowData("منطقة التوصيل", "شارع الهرم"),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                      child: const Text("قبول"),
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

  DataRow _rowData(String title, String value) {
    return DataRow(
      cells: <DataCell>[
        DataCell(
          FittedBox(child: Text(title)),
        ),
        DataCell(
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: 150,
              child: Text(
                value,
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
