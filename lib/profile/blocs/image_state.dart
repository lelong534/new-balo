import 'package:equatable/equatable.dart';
import 'package:flutter_zalo_bloc/profile/models/image_response.dart';

class ImageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReceivedImageState extends ImageState {
  final ImageResponse images;

  ReceivedImageState(this.images);

  @override
  List<Object> get props => [images];

  @override
  String toString() => 'Received Image';
}

class ErrorImageState extends ImageState {
  final String errorMessage;

  ErrorImageState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'Error: ' + errorMessage;
}

class LoadingImageState extends ImageState {
  @override
  List<Object> get props => [toString()];

  @override
  String toString() => 'Loading';
}