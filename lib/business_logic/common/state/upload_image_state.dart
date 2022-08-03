abstract class UploadImageState {}

class UploadImageInitial extends UploadImageState {}

class LoadingState extends UploadImageState {}

class SuccessState extends UploadImageState {
  final String imageUrl;
  SuccessState(this.imageUrl);
}

class FailedState extends UploadImageState {
  final String message;
  FailedState(this.message);
}

class ErrorState extends UploadImageState {}
