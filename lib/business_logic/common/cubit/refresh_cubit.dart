import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/reresh_state.dart';

class RefreshCubit extends Cubit<RefreshState> {
  RefreshCubit() : super(Refresh());

  void refresh() => emit(Refresh());
}
