import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../business_logic/common/cubit/spinner_cubit.dart';
import '../../../constants/enums.dart';

class Spinner extends StatelessWidget {
  const Spinner(this.hint, this.items, this.spinnerEnum, {Key? key})
      : super(key: key);
  final String hint;
  final List<String> items;
  final SpinnerEnum spinnerEnum;

  @override
  Widget build(BuildContext context) {
    final state = BlocProvider.of<SpinnerCubit>(context);
    return Container(
      margin: const EdgeInsets.all(10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        hint: Text(hint),
        onChanged: (value) {
          if (value != null) {
            switch (spinnerEnum) {
              case SpinnerEnum.paymentState:
                try {
                  state.changePaymentSate(value);
                } catch (e) {
                  Logger().e(e);
                }
                break;
              case SpinnerEnum.preparationTime:
                state.changePreparationState(value);
                break;
              case SpinnerEnum.zone:
                state.getZoneName(value);
                break;
              default:
                break;
            }
          }
        },
        items: items.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            alignment: AlignmentDirectional.centerEnd,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
