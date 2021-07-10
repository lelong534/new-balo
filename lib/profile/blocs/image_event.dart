class ImageEvent {}

class LoadingImageEvent extends ImageEvent {
  final int userId;
  LoadingImageEvent(this.userId);
}
