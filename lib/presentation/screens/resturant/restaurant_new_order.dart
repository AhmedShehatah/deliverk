import 'package:deliverk/business_logic/common/state/generic_state.dart';
import 'package:deliverk/business_logic/restaurant/cubit/new_order_cubit.dart';
import 'package:deliverk/data/models/common/order_model.dart';
import 'package:deliverk/helpers/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:hive/hive.dart';

import '../../../business_logic/common/cubit/spinner_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../constants/enums.dart';
import '../../widgets/common/spinner.dart';
import '../../widgets/common/text_field.dart';

class RestaurantNewOrder extends StatefulWidget {
  const RestaurantNewOrder({Key? key}) : super(key: key);

  @override
  State<RestaurantNewOrder> createState() => _RestaurantNewOrderState();
}

class _RestaurantNewOrderState extends State<RestaurantNewOrder> {
  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _preparationController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void clearInputs() {
    _priceController.clear();
    _preparationController.clear();
    _notesController.clear();
    _areaContrller.clear();
    _pay = null;
    _prep = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اضافة طلب"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeaderPhoto(context),
              Form(key: _formKey, child: _buildOrderDetails(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderPhoto(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Image.asset("assets/images/order.gif"),
    );
  }

  bool _isForRest = false;

  Widget _buildOrderDetails(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('طلب للمطعم'),
                ),
                Switch(
                    value: _isForRest,
                    onChanged: (value) {
                      setState(() {
                        _isForRest = !_isForRest;
                        clearInputs();
                      });
                    }),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _buildPlaceAutoFill(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('تكلفة التوصيل ' +
                  (areas[_areaContrller.text] == null
                      ? ''
                      : areas[_areaContrller.text]!['cost'].toString())),
            ),
            if (!_isForRest)
              Row(
                children: [
                  Expanded(
                    child: Spinner(
                      _prep == null ? "مدة التحضير" : _prep!,
                      const ["جاهز", "غير جاهز"],
                      SpinnerEnum.preparationTime,
                    ),
                  ),
                  Expanded(
                    child: _buildPaymentStatus(),
                  ),
                ],
              ),
            if (!_isForRest) _buildFields(context),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomTextField(
                inputType: TextInputType.text,
                controller: _notesController,
                hint: 'ملاحظات',
                validator: (_isForRest && _notesController.text.isEmpty)
                    ? 'ادخل بيانات الطلب'
                    : null,
              ),
            ),
            Row(
              children: [
                const Spacer(),
                BlocBuilder<NewOrderCubit, GenericState>(
                  builder: (context, state) {
                    if (state is GenericSuccessState) {
                      Fluttertoast.showToast(msg: 'تم اضافة الطلب بنجاح');
                      Navigator.pop(context);
                    } else if (state is GenericLoadingState) {
                      return const CircularProgressIndicator(
                        color: Colors.blue,
                      );
                    } else if (state is GenericFailureState) {
                      Fluttertoast.showToast(msg: state.data as String);
                    }
                    return SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          addOrder(context);
                        },
                        child: const Text("اضافة"),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String? _pay;
  String? _prep;
  Widget _buildFields(BuildContext context) {
    return BlocBuilder<SpinnerCubit, SpinnerState>(
      builder: (ctx, state) {
        if (state is SpinnerInitial) {
          _pay = state.paymentState;
          _prep = state.preparationState;
          if (state.paymentState == "غير مدفوع" &&
              state.preparationState == "غير جاهز") {
            return Row(
              children: [
                Expanded(child: _buildPreparationField()),
                Expanded(child: _buildPriceField()),
              ],
            );
          } else if (state.paymentState == "غير مدفوع") {
            return _buildPriceField();
          } else if (state.preparationState == "غير جاهز") {
            return _buildPreparationField();
          } else {
            return const Text('');
          }
        }

        return const Text('');
      },
    );
  }

  Widget _buildPreparationField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CustomTextField(
        controller: _preparationController,
        hint: "مدة التجهيز",
        inputType: TextInputType.number,
        validator: (_preparationController.text.isEmpty) ? 'ادخل المدة' : null,
      ),
    );
  }

  Widget _buildPriceField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CustomTextField(
        controller: _priceController,
        hint: "سعر الطلب",
        inputType: TextInputType.number,
        validator: (_priceController.text.isEmpty) ? 'ادخل سعر الطلب' : null,
      ),
    );
  }

  Widget _buildPaymentStatus() {
    return Spinner(
      _pay == null ? "حالة الدفع" : _pay!,
      const ["مدفوع", "غير مدفوع"],
      SpinnerEnum.paymentState,
    );
  }

  final List<String> _places = [];
  final Map<String, Map<String, int>> areas = {};
  var _areaContrller = TextEditingController();
  Widget _buildPlaceAutoFill() {
    return Autocomplete<String>(
      fieldViewBuilder: (BuildContext context, controller, FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        _areaContrller = controller;
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: (value) {
            if (value == null || areas[value] == null) {
              return 'ادخل منطقة موجودة';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            label: const Text("المنطقة"),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
        );
      },
      optionsBuilder: ((textEditingValue) {
        setState(() {});
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }

        return _places.where((String option) {
          Logger().d(option);
          return option.contains(textEditingValue.text.toLowerCase());
        });
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    initAreas();
    _notesController.addListener(listener);
    _priceController.addListener(listener);
    _preparationController.addListener(listener);
  }

  void listener() {
    setState(() {});
  }

  initAreas() async {
    var box = await Hive.openBox<Map<String, Map<String, int>>>('area_price');
    var data = box.get('cost');
    if (data != null) {
      data.forEach((key, value) {
        areas[key] = {'cost': value['cost']!, 'id': value['id']!};
        _places.add(key);
      });

      setState(() {});

      Logger().d(areas);
    }
  }

  void addOrder(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (!_isForRest && (_pay == null || _prep == null)) {
        Fluttertoast.showToast(msg: 'من فضلك ادخل مدة التحضير وحالة الدفع');
        return;
      }
      var order = OrderModel();
      order
        ..areaId = areas[_areaContrller.text]!['id']
        ..zoneId = DeliverkSharedPreferences.getZoneId()
        ..resId = DeliverkSharedPreferences.getRestId()
        ..isPaid = _priceController.text.isEmpty ? true : false
        ..notes = _notesController.text.isEmpty ? null : _notesController.text
        ..duration = _preparationController.text.isNotEmpty
            ? int.parse(_preparationController.text)
            : null
        ..status = (order.duration == null)
            ? OrderType.cooked.name
            : OrderType.cooking.name
        ..cost = _priceController.text.isNotEmpty
            ? int.parse(_priceController.text)
            : null;
      Logger().d(order.toJson());
      BlocProvider.of<NewOrderCubit>(context).addOrder(
        order.toJson(),
        DeliverkSharedPreferences.getToken()!,
      );
    }
  }
}
