import 'package:deliverk/business_logic/common/state/reresh_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshCubit extends Cubit<RefreshState> {
  RefreshCubit() : super(Refresh());

  void refresh() => emit(Refresh());
}
