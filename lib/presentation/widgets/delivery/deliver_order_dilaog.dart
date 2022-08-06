import 'package:deliverk/business_logic/common/cubit/patch_order_cubit.dart';
import 'package:deliverk/business_logic/common/state/generic_state.dart';

import 'package:deliverk/constants/strings.dart';
import 'package:deliverk/data/models/restaurant/restaurant_model.dart';
import 'package:deliverk/helpers/shared_preferences.dart';
import 'package:deliverk/repos/delivery/delivery_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryOrderDetialsDialog extends StatefulWidget {
  const DeliveryOrderDetialsDialog(
      this.order, this.restData, this.areaName, this.isDelivering,
      {Key? key})
      : super(key: key);
  final dynamic order;
  final RestaurantModel restData;
  final String areaName;
  final bool isDelivering;

  @override
  State<DeliveryOrderDetialsDialog> createState() =>
      _DeliveryOrderDetialsDialogState();
}

class _DeliveryOrderDetialsDialogState
    extends State<DeliveryOrderDetialsDialog> {
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
                    _rowData(" اسم المطعم", widget.restData.name!),
                    _rowData("مكان المطعم", widget.restData.address!),
                    _mapRow("مكان المطعم", "اظهر على الخريطة"),
                    _rowData("كود الطلب", widget.order.id!.toString()),
                    _rowData(
                        "تكلفة التوصيل", widget.order.areaCost!.toString()),
                    _rowData("منطقة التوصيل", widget.areaName),
                  ],
                ),
                if (!widget.isDelivering)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showAlertDialog(context);
                        },
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

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("الغاء"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = BlocBuilder<PatchOrderCubit, GenericState>(
      builder: (context, state) {
        if (state is GenericSuccessState) {
          Navigator.pop(context);
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
          child: const Text("تاكيد"),
          onPressed: () {
            BlocProvider.of<PatchOrderCubit>(context, listen: false).patchOrder(
                widget.order.id!,
                {'delv_id': DeliverkSharedPreferences.getDelivId() ?? 15});
          },
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("رسالة تأكيد"),
      content: const Text("هل تريد تأكيد الطلب"),
      actions: [
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

  DataRow _mapRow(String title, String value) {
    return DataRow(
      cells: <DataCell>[
        DataCell(
          FittedBox(child: Text(title)),
        ),
        DataCell(
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, mapShowScreen,
                  arguments: LatLng(
                    double.parse(widget.restData.mapLat!),
                    double.parse(widget.restData.mapLong!),
                  ));
            },
            child: FittedBox(
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
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
