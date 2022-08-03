abstract class GenericState {}

class GenericStateInit extends GenericState {}

class GenericLoadingState extends GenericState {}

class GenericSuccessState extends GenericState {
  final dynamic data;
  GenericSuccessState(this.data);
}

class GenericFailureState extends GenericState {
  final dynamic data;
  GenericFailureState(this.data);
}

class GenericErrorState extends GenericState {}
