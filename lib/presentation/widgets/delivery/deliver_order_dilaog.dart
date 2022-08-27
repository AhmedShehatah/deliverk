import '../../../business_logic/common/cubit/patch_order_cubit.dart';
import '../../../business_logic/common/state/generic_state.dart';
import '../../../constants/enums.dart';

import '../../../constants/strings.dart';
import '../../../data/models/delivery/zone_order.dart';

import '../../../data/models/restaurant/restaurant_model.dart';
import '../../../helpers/time_cal.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryOrderDetialsDialog extends StatefulWidget {
  const DeliveryOrderDetialsDialog(
      this.order, this.restData, this.areaName, this.isDelivering,
      {Key? key})
      : super(key: key);
  final ZoneOrder order;
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
                    _rowData('رقم المطعم', widget.restData.phone!),
                    _rowData('تاريخ الطلب',
                        TimeCalc.calcTime(widget.order.createdAt!).toString()),
                    _mapRow("مكان المطعم", "اظهر على الخريطة"),
                    _rowData("كود الطلب", widget.order.id!.toString()),
                    _rowData(
                        "تكلفة التوصيل", widget.order.delvCash!.toString()),
                    _rowData("منطقة التوصيل", widget.areaName),
                    if (widget.order.notes != null)
                      _rowData('ملاحظات', widget.order.notes!),
                  ],
                ),
                _buildActionButton(),
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
          FittedBox(fit: BoxFit.scaleDown, child: Text(title)),
        ),
        DataCell(
          FittedBox(
            fit: BoxFit.scaleDown,
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

  Widget _buildActionButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!widget.isDelivering)
          BlocBuilder<PatchOrderCubit, GenericState>(
            builder: (context, state) {
              if (state is GenericSuccessState) {
                Fluttertoast.showToast(msg: 'تم حجز الطلب بنجاح');
                Navigator.of(context).pop(true);
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
              return ElevatedButton(
                onPressed: () {
                  // showAlertDialog(context);
                  BlocProvider.of<PatchOrderCubit>(context, listen: false)
                      .patchOrder(widget.order.id!, {
                    // 'delv_id': DeliverkSharedPreferences.getDelivId()!,
                    'status': OrderType.coming.name
                  });
                },
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                child: const Text("قبول"),
              );
            },
          )
        else if (widget.order.status == OrderType.delivering.name)
          BlocBuilder<PatchOrderCubit, GenericState>(
            builder: (context, state) {
              if (state is GenericLoadingState) {
                return const CircularProgressIndicator(
                  color: Colors.blue,
                );
              } else if (state is GenericSuccessState) {
                Fluttertoast.showToast(msg: 'تمت العملية بنجاح');
                Navigator.of(context).pop(true);
              } else if (state is GenericFailureState) {
                Fluttertoast.showToast(msg: state.data);
                Navigator.pop(context);
              }

              return ElevatedButton(
                onPressed: () {
                  BlocProvider.of<PatchOrderCubit>(context).patchOrder(
                      widget.order.id!, {'status': OrderType.received.name},
                      booking: "/booking");
                },
                child: const Text('تم التوصيل'),
                style: ElevatedButton.styleFrom(primary: Colors.green),
              );
            },
          )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
